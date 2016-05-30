require_relative 'parameters'

module Pacto
  module Swagger
    module ContractMapper

      def self.map(contract)
         path = contract["request"]["path"]
         swagger = contract['swagger'] || {}
         swagger_params = swagger['parameters'] || {}
         request_schema = contract["request"]["schema"]

         return Pacto::Swagger::Parameters.build(path, request_schema, swagger_params)

      end
    end
  end
end
