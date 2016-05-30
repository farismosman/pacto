module Pacto
  module Swagger
    module Parameters

      def self.parameter(name, param_in, properties)
        return {
          "name" => properties['name'] || name,
          "in" => properties['in'] || param_in,
          "description" => properties['description'],
          "required" => properties['required'].nil? ? true : properties['required'],
          "type" => properties['type']
        }
      end

      def self.build_body_parameters(schema)
        unless schema.nil? || schema.empty?
          return [{
            "name" => "body",
            "description" => "Request Body",
            "in" => "body",
            "schema" => schema,
            "required" => true
          }]
        end
        return []
      end

      def self.build_query_parameters(query, parameters)
        result = []
        unless query.nil?
          params = CGI::parse(query)
          params.each_key do |key|
            properties = parameters[key]
            result.push(parameter(key, 'query', properties))
          end
        end
        return result
      end

      def self.build_path_parameters(path, parameters)
        result = []
        resources = path.split('/')
        parameters.each do |key, value|
          if resources.include? key
            result.push(parameter(nil, 'path', value))
          end
        end
        return result
      end

      def self.build(path, schema, parameters)
        swagger_parameters = []
        url = URI.parse(path)
        query = url.query
        path = url.path

        swagger_parameters.push(build_query_parameters(query, parameters))
        swagger_parameters.push(build_path_parameters(path, parameters))
        swagger_parameters.push(build_body_parameters(schema))

        return swagger_parameters.flatten!
      end
    end
  end
end
