module Pacto
  module Swagger
    module Responses
      def self.get(contract)
        responses = {}
        status = contract['response']['status']
        responses[status] = {}
        responses[status]['description'] = contract['response']['description']
        responses[status]['schema'] = contract['response']['schema']
        return responses
      end
    end
  end
end
