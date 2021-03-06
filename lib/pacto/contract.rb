module Pacto
  class Contract < Hashie::Dash
    include Hashie::Extensions::Coercion
    property :file
    property :request,  required: true
    # Although I'd like response to be required, it complicates
    # the partial contracts used the rake generation task...
    # yet another reason I'd like to deprecate that feature
    property :response # , required: true
    property :values, default: {}
    # Gotta figure out how to use test doubles w/ coercion
    coerce_key :request,  RequestClause
    coerce_key :response, ResponseClause
    property :examples
    property :name, required: true
    property :request_pattern_provider, default: Pacto::RequestPattern
    property :adapter, default: proc { Pacto.configuration.adapter }
    property :consumer, default: proc { Pacto.configuration.default_consumer }
    property :provider, default: proc { Pacto.configuration.default_provider }

    def initialize(opts)
      if opts[:file]
        opts[:file] = Addressable::URI.convert_path(File.expand_path(opts[:file])).to_s
        opts[:name] ||= opts[:file]
      end
      super
    end

    def examples?
      examples && !examples.empty?
    end

    def stub_contract!(values = {})
      self.values = values
      adapter.stub_request!(self)
    end

    def simulate_request
      pacto_request, pacto_response = execute
      validate_response pacto_request, pacto_response
    end

    # Should this be deprecated?
    def validate_response(request, response)
      Pacto::Cops.perform_investigation request, response, self
    end

    def matches?(request_signature)
      request_pattern.matches? request_signature
    end

    def request_pattern
      @request_pattern ||= request_pattern_provider.for(request)
    end

    def response_for(pacto_request, example = nil)
      provider.response_for self, pacto_request, example
    end

    def execute(additional_values = {})
      # FIXME: Do we really need to store on the Contract, or just as a param for #stub_contact! and #execute?
      full_values = values.merge(additional_values)
      consumer.reenact(self, full_values)
    end
  end
end
