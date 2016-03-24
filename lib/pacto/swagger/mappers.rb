module Pacto
  module Swagger
    module Path
      def self.get(contract)
        url = URI.parse(contract["request"]["path"])
        return url.path
      end
    end

    module Parameters

      def self.param(name)
        return {
          "name" => name,
          "in" => "query",
          "description" => "Query Parameter",
          "required" => true,
          "type" => "string"
          }
      end

      def self.body(schema)
        body = param("body")
        body['description'] = "Request Body"
        body['in'] = 'body'
        body['schema'] = schema
        body.delete('type')
        return body
      end

      def self.get(contract)
         parameters = []
         url = URI.parse(contract["request"]["path"])
         request_schema = contract["request"]["schema"]
         query = url.query

         unless query.nil?
           params = CGI::parse(query)

           params.each do |key, value|
             parameters.push(param(key))
           end
         end

         unless request_schema.empty?
           parameters.push(body(request_schema))
         end
       return parameters
      end
    end

  end
end

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
