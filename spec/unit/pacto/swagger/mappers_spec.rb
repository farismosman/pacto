module Pacto
  module Swagger

      describe 'endpoint path' do
        it 'should get parameters from contract' do
          contract = {
            'request' => {
              'path' => 'www.host.com/users?name=dude',
              'schema' => {}
            }
          }

          obj = Pacto::Swagger::Parameters.get(contract)

          expect(obj).to eq([{
            "name" => 'name',
            "in" => "query",
            "description" => "param_description",
            "required" => true,
            "type" => "string"
            }])
        end

        it 'should get multiple parameters from contract' do
          contract = {
            'request' => {
              'path' => 'www.host.com/users?name=dude&age=10',
              'schema' => {}
            }
          }

          obj = Pacto::Swagger::Parameters.get(contract)

          expect(obj).to eq([{
            "name" => 'name',
            "in" => "query",
            "description" => "param_description",
            "required" => true,
            "type" => "string"
            },
            {
              "name" => 'age',
              "in" => "query",
              "description" => "param_description",
              "required" => true,
              "type" => "string"
              }
              ])
        end

        it 'should get parameters with body from contract' do
          schema = {
            "$schema" => "http://json-schema.org/draft-04/schema#",
            "type" => "object",
            "properties" => {
              "items" => {
                "type" => "array",
                "items" => {
                  "type" => "object",
                  "properties" => {
                    "itemId" => {
                      "type" => "string"
                    }
                  }
                }
              }
            }
          }
          contract = {
            'request' => {
              'path' => 'www.host.com/users?name=dude',
              'schema' => schema
            }
          }

          obj = Pacto::Swagger::Parameters.get(contract)

          expect(obj).to eq([{
            "name" => 'name',
            "in" => "query",
            "description" => "param_description",
            "required" => true,
            "type" => "string"
            },
            {
             "name" => "body",
             "in" => "body",
             "description" => "Request body",
             "required" => true,
             "schema" => schema
            }
            ])
        end
    end
  end
end
