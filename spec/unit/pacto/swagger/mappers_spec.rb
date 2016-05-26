module Pacto
  module Swagger

      describe 'endpoint path' do

        it 'should handle path with no params' do
          contract = {
            'request' => {
              'path' => 'www.host.com/users',
              'schema' => {}
            }
          }

          obj = Pacto::Swagger::Parameters.get(contract)

          expect(obj).to eq([])
        end

        it 'should get a single parameter from contract with defaults' do
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
            "description" => "Query Parameter",
            "required" => true,
            "type" => "string"
            }])
        end

        it 'should get parameters description from contract' do
          contract = {
            'request' => {
              'path' => 'www.host.com/users?name=dude',
              'parameters' => {
                'name' => {
                  'description'=> 'First name of the user',
                  'required' => false,
                  'in' => 'path',
                  'type' => 'string'
                }
              },
              'schema' => {}
            }
          }

          obj = Pacto::Swagger::Parameters.get(contract)

          expect(obj).to eq([{
            "name" => 'name',
            "in" => "path",
            "description" => "First name of the user",
            "required" => false,
            "type" => "string"
            }
          ])
        end

        it 'should get parameters description from contract and set rest to default' do
          contract = {
            'request' => {
              'path' => 'www.host.com/users?name=dude',
              'parameters' => {'name' =>
                {
                  'description'=> 'First name of the user',
                  'type' => 'string'
                }
              },
              'schema' => {}
            }
          }

          obj = Pacto::Swagger::Parameters.get(contract)

          expect(obj).to eq([{
            "name" => 'name',
            "in" => "query",
            "description" => "First name of the user",
            "required" => true,
            "type" => "string"
            }
          ])
        end

        it 'should not get parameters that do not exist' do
          contract = {
            'request' => {
              'path' => 'www.host.com/users?name=dude',
              'parameters' => {'age' =>
                {
                  'description'=> 'First name of the user',
                  'type' => 'string'
                }
              },
              'schema' => {}
            }
          }

          obj = Pacto::Swagger::Parameters.get(contract)

          expect(obj).to eq([{
            "name" => 'name',
            "in" => "query",
            "description" => "Query Parameter",
            "required" => true,
            "type" => "string"
            }
          ])
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
            "description" => "Query Parameter",
            "required" => true,
            "type" => "string"
            },
            {
              "name" => 'age',
              "in" => "query",
              "description" => "Query Parameter",
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
            "description" => "Query Parameter",
            "required" => true,
            "type" => "string"
            },
            {
             "name" => "body",
             "in" => "body",
             "description" => "Request Body",
             "required" => true,
             "schema" => schema
            }
            ])
      end
    end

    describe 'endpoint response' do
      it 'should build swagger response' do
        contract = {
          'response' => {
            'status' => 200,
            'description' => 'Response description',
            'schema' => {}
          }
        }

        obj = Pacto::Swagger::Responses.get(contract)

        expect(obj).to eq({
            200=>{
              "description"=>"Response description",
              "schema"=>{}
            }
          })
      end
    end

    describe 'http method' do
      it 'should get http method from contract' do
        contract = {
          'request' => {
            'http_method' => 'GET'
          }
        }

        http_method = Pacto::Swagger::HttpMethod.get(contract)

        expect(http_method).to eq('get')
      end
    end
  end
end
