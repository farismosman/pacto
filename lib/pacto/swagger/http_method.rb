module Pacto
  module Swagger
    module HttpMethod
      def self.get(contract)
        http_method = contract['request']['http_method']
        return http_method.downcase
      end
    end
  end
end
