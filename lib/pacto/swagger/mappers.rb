require_relative 'parameters'

module Pacto
  module Swagger
    module ContractMapper
      def self.map(contract)
         parameters = []
         url = URI.parse(contract["request"]["path"])
         swagger = contract['swagger'] || {}
         swagger_params = swagger['parameters'] || {}
         request_schema = contract["request"]["schema"]
         query = url.query

         unless query.nil?
           params = CGI::parse(query)

           params.each do |key, value|
             parameters.push(Pacto::Swagger::Parameters.get_url_query(key, swagger_params[key]))
           end
         end

         unless request_schema.nil? || request_schema.empty?
           parameters.push(Pacto::Swagger::Parameters.get_request_body(request_schema))
         end
       return parameters
      end
    end
  end
end
