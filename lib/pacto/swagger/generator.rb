require_relative 'mappers'

module Pacto
  module Swagger
    module Generator
      def self.load_contract(path_to_file)
        content = File.read(path_to_file)
        return JSON.parse(content)
      end

      def self.swagger_object(config, request)
        return JSON.pretty_generate ({
                "swagger" => "2.0",
                "info" => {
                  "version" => config['version'],
                  "title" => config['title'],
                  "description" => config['description'],
                  "contact" => {
                    "name" => config['contact'],
                    "email" => config['email']
                  }
                },
                "externalDocs" => {
                  "description" => "find more info here",
                  "url" => "https://swagger.io/about"
                },
                "host" => config['host'],
                "basePath" => config['basePath'],
                "schemes" => ["http"],
                "consumes" => ["application/json"],
                "produces" => ["application/json"],
                "paths" => request
              })
      end

      def self.document(path_to_contract)
        contract = load_contract(path_to_contract)
        path = Swagger::Path.get(contract)
        http_method = Swagger::HttpMethod.get(contract)

        request = {path => {
          http_method => {}
          }
        }
        request[path][http_method]['parameters'] = Swagger::Parameters.get(contract)
        request[path][http_method]['responses'] = Swagger::Responses.get(contract)
        request[path][http_method]['description'] = contract['description']
        request[path][http_method]['operationId'] = contract['operationId']
        request[path][http_method]['produces'] = ['application/json']

        return path, request
      end

      def self.generate(config)
        paths = {}
        path_to_contracts = config['contracts']
        path_to_swagger_document = config['swagger_document']

        for path_to_contract in path_to_contracts
          content = document(path_to_contract)
          path = content.first()
          doc = content.last()
          paths.has_key?(path) ? paths[path].merge!(doc[path]) : paths.merge!(doc)
        end

        File.open(path_to_swagger_document, 'w') do |file|
          file.write(swagger_object(config, paths))
          puts Pacto::UI.green("Generated a swagger document in #{path_to_swagger_document}")
        end
      end

    end
  end
end
