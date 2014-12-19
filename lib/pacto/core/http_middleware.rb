require 'observer'

module Pacto
  module Core
    class HTTPMiddleware
      include Logger
      include Observable

      def initialize
        @contract_map = {}
      end

      def process(request, response)
        contracts = Pacto.contracts_for request
        Pacto.configuration.hook.process contracts, request, response

        changed
        notify_observers request, response, { :contract => @contract_map[request.webmock_request_signature] }
      end

      def register_contract request, contract, example
        @contract_map[request] = contract
      end
    end
  end
end
