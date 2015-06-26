module Pacto
  module Actors
    class FirstExampleSelector
      def self.select(examples, _values)
        Hashie::Mash.new examples.values.first
      end
    end
    class RandomExampleSelector
      def self.select(examples, _values)
        Hashie::Mash.new examples.values.sample
      end
    end
    class NamedExampleSelector
      def self.select(examples, values)
        name = values[:example_name]
        if name.nil?
          RandomExampleSelector.select(examples, values)
        else
          Hashie::Mash.new examples[name]
        end
      end
    end
    class FromExamples
      def initialize(fallback_actor = JSONGenerator, selector = Pacto::Actors::NamedExampleSelector)
        @fallback_actor = fallback_actor
        @selector = selector
      end

      def build_request(contract, values = {}, example = nil)
        if contract.examples?
          example = find_example(contract.examples, values, example)
          data = contract.request.to_hash
          data['uri'] = contract.request.uri
          data['body'] = example.request.body
          data['method'] = contract.request.http_method
          data['headers'].merge! example.request.headers || {}
          Pacto::PactoRequest.new(data)
        else
          @fallback_actor.build_request contract, values
        end
      end

      def build_response(contract, values = {}, example = nil)
        if contract.examples?
          example = find_example(contract.examples, values, example)
          data = contract.response.to_hash
          if example.status
            data['status'] = example.status
          elsif data['status'].is_a? Array
            data['status'] = data['status'].first
          end
          data['headers'].merge! example.response.headers || {}
          data['body'] = example.response.body
          Pacto::PactoResponse.new(data)
        else
          @fallback_actor.build_response contract, values
        end
      end

      private

      def find_example(examples, values, example)
        if example.nil?
          @selector.select(examples, values)
        else
          Hashie::Mash.new example
        end
      end
    end
  end
end
