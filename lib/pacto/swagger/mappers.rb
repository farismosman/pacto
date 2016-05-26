module Pacto
  module Swagger
    module Path
      def self.get(contract)
        url = URI.parse(contract["request"]["path"])
        return url.path
      end
    end

    module Parameters

      def self.param(name, properties)
        properties ||= {}
        properties['in'] ||= 'query'
        properties['description'] ||= "Query Parameter"
        properties['type'] ||= "string"
        properties['required'] = true if properties['required'].nil?

        return {
          "name" => name,
          "in" => properties['in'],
          "description" => properties['description'],
          "required" => properties['required'],
          "type" => properties['type']
          }
      end

      def self.body(schema)
        properties = {}
        body = param("body", properties)
        body['description'] = "Request Body"
        body['in'] = 'body'
        body['schema'] = schema
        body.delete('type')
        return body
      end

      def self.get(contract)
         parameters = []
         url = URI.parse(contract["request"]["path"])
         properties = contract['request']['parameters'] || {}
         request_schema = contract["request"]["schema"]
         query = url.query

         unless query.nil?
           params = CGI::parse(query)

           params.each do |key, value|
             parameters.push(param(key, properties[key]))
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
