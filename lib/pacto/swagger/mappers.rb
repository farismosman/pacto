require 'cgi'

module Pacto
  module Swagger
    module Path

      def self.get(contract)
        url = URI.parse(contract["request"]["path"])
        return url.path
      end

    end
  end
end

module Pacto
  module Swagger
    module Parameters
      def self.get(contract)
         parameters = []
         url = URI.parse(contract["request"]["path"])
         request_schema = contract["request"]["schema"]
         query = url.query
         params = CGI::parse(query)
         params.each do |key, value|
             parameters.push(
             {
               "name" => key,
               "in" => "query",
               "description" => "param_description",
               "required" => true,
               "type" => "string"
             }
           )
         end
         unless request_schema.empty?
           parameters.push(
            {
             "name" => "body",
             "in" => "body",
             "description" => "Request body",
             "required" => true,
             "schema" => request_schema
            }
           )
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
