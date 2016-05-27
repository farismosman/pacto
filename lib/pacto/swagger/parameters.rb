module Pacto
  module Swagger
    module Parameters
      def self.get_url_query(name, swagger_params)
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

      def self.get_request_body(schema)
        body = get_url_query("body", {})
        body['description'] = "Request Body"
        body['in'] = 'body'
        body['schema'] = schema
        body.delete('type')
        return body
      end

    end
  end
end
