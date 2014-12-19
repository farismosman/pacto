module Pacto
  module Adapters
    module WebMock
      class PactoRequest < Pacto::PactoRequest
        extend Forwardable
        def_delegators :@webmock_request_signature, :headers, :method, :body, :uri, :to_s

        def initialize(webmock_request_signature)
          @webmock_request_signature = webmock_request_signature
        end

        def params
          @webmock_request_signature.uri.query_values
        end

        def path
          @webmock_request_signature.uri.path
        end

        def webmock_request_signature
          @webmock_request_signature
        end
      end

      class PactoResponse < Pacto::PactoResponse
        extend Forwardable
        def_delegators :@webmock_response, :body, :body=, :headers=, :status=, :to_s

        def initialize(webmock_response)
          @webmock_response = webmock_response
        end

        def headers
          @webmock_response.headers || {}
        end

        def status
          status, _ = @webmock_response.status
          status
        end
      end
    end
  end
  module Stubs
    class WebMockAdapter
      include Resettable

      def initialize(middleware)
        @middleware = middleware

        WebMock.after_request do |webmock_request_signature, webmock_response|
          process_hooks webmock_request_signature, webmock_response
        end
      end

      def stub_request!(contract)
        request_clause = contract.request
        uri_pattern = UriPattern.for(request_clause)

        if contract.examples?

          contract.examples.each do |name, example|
            request_match = name == 'default' ? {} : { body: WebMock.hash_including(example['request']['body']) }
            stub = WebMock.stub_request(request_clause.http_method, uri_pattern)
            stub = stub.with(request_match)
            stub.to_return do |request_signature|
              @middleware.register_contract(request_signature, contract, example)
              response = build_response contract, request_signature, example
            end
          end

        else
          stub = WebMock.stub_request(request_clause.http_method, uri_pattern)
          stub = stub.with(strict_details(request_clause)) if Pacto.configuration.strict_matchers

          stub.to_return do |request|
            build_response contract, request
          end
        end
      end

      def self.reset!
        WebMock.reset!
        WebMock.reset_callbacks
      end

      def process_hooks(webmock_request_signature, webmock_response)
        pacto_request = Pacto::Adapters::WebMock::PactoRequest.new webmock_request_signature
        pacto_response = Pacto::Adapters::WebMock::PactoResponse.new webmock_response
        @middleware.process pacto_request, pacto_response
      end

      private

      def build_response(contract, request, example = nil)
        pacto_request = Pacto::Adapters::WebMock::PactoRequest.new request
        response = contract.response_for pacto_request, example
        {
          status: response.status,
          headers: response.headers,
          body: format_body(response.body)
        }
      end

      def format_body(body)
        if body.is_a?(Hash) || body.is_a?(Array)
          body.to_json
        else
          body
        end
      end

      def strict_details(request)
        {}.tap do |details|
          details[webmock_params_key(request)] = request.params unless request.params.empty?
          details[:headers] = request.headers unless request.headers.empty?
        end
      end

      def webmock_params_key(request)
        request.http_method == :get ? :query : :body
      end
    end
  end
end
