module Pacto
  module Swagger
    module Path
      def self.get(contract)
        url = URI.parse(contract["request"]["path"])
        return url.path
      end
    end

    module Parameters

      def self.param(name, swagger_params)
        swagger_params ||= {}
        swagger_params['in'] ||= 'query'
        swagger_params['description'] ||= "Query Parameter"
        swagger_params['type'] ||= "string"
        swagger_params['required'] = true if swagger_params['required'].nil?

        return {
          "name" => name,
          "in" => swagger_params['in'],
          "description" => swagger_params['description'],
          "required" => swagger_params['required'],
          "type" => swagger_params['type']
          }
      end

      def self.body(schema)
        swagger_params = {}
        body = param("body", swagger_params)
        body['description'] = "Request Body"
        body['in'] = 'body'
        body['schema'] = schema
        body.delete('type')
        return body
      end

      def self.get(contract)
         parameters = []
         url = URI.parse(contract["request"]["path"])
         swagger = contract['swagger'] || {}
         swagger_params = swagger['parameters'] || {}
         request_schema = contract["request"]["schema"]
         query = url.query

         unless query.nil?
           params = CGI::parse(query)

           params.each do |key, value|
             parameters.push(param(key, swagger_params[key]))
           end
         end

         unless request_schema.nil? || request_schema.empty?
           parameters.push(body(request_schema))
         end
       return parameters
      end
    end

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

    module HttpMethod
      def self.get(contract)
        http_method = contract['request']['http_method']
        return http_method.downcase
      end
    end
  end
end
