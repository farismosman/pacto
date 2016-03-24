module Pacto
  module Swagger
    module Generator
        describe 'swagger object' do
          it 'should use config object' do
            config = {
              'version' => '1.0',
              'title'=> 'api doc',
              'description'=> 'this is our api doc',
              'contact'=> 'awesome team',
              'email'=> 'awesomeness@test.com',
              'host'=> 'api.some.com',
              'basePath'=> '/'
            }

            obj = JSON.parse(Pacto::Swagger::Generator.swagger_object(config, {}))

            expect(obj['info']).to eq({
               "version" => "1.0",
               "title" => "api doc",
               "description" => "this is our api doc",
               "contact" => {
                 "name" => "awesome team",
                 "email" => "awesomeness@test.com"
               }
             })

             expect(obj['host']).to eq("api.some.com")
             expect(obj['basePath']).to eq("/")
             expect(obj['paths']).to eq({})
          end

          it 'should generate object from json contract' do
            contract = 'spec/fixtures/contracts/simple_contract.json'

            obj = Pacto::Swagger::Generator.document(contract)

            expect(obj.first()).to eq('/hello')
            expect(obj.last()).to eq({
               "/hello"=>{
                  "get"=>{
                     "parameters"=>[

                     ],
                     "responses"=>{
                        200=>{
                           "description"=>nil,
                           "schema"=>{
                              "$schema"=>"http://json-schema.org/draft-03/schema#",
                              "type"=>"object",
                              "required"=>true,
                              "properties"=>{
                                 "message"=>{
                                    "type"=>"string",
                                    "required"=>true
                                 }
                              }
                           }
                        }
                     },
                     "description"=>nil,
                     "operationId"=>nil,
                     "produces"=>[
                        "application/json"
                     ]
                  }
               }
            })
          end

        it 'should generate swagger document for multiple contracts' do
          config = {
            'version' => '1.0',
            'title'=> 'api doc',
            'description'=> 'this is our api doc',
            'contact'=> 'awesome team',
            'email'=> 'awesomeness@test.com',
            'host'=> 'api.some.com',
            'basePath'=> '/',
            'swagger_document' => 'spec/fixtures/swagger/swagger.json',
            'contracts' => [
              'spec/fixtures/contracts/simple_contract.json',
              'spec/fixtures/contracts/contract.json'
            ]
          }

          Pacto::Swagger::Generator.generate(config)
          content = JSON.parse(File.read(config['swagger_document']))

          expect(content).to eq({
            "swagger"=>"2.0",
            "info"=>{
              "version"=>"1.0",
              "title"=>"api doc",
              "description"=>"this is our api doc",
              "contact"=>{
                "name"=>"awesome team",
                "email"=>"awesomeness@test.com"
              }
            },
            "externalDocs"=>{
              "description"=>"find more info here",
              "url"=>"https://swagger.io/about"
            },
            "host"=>"api.some.com",
            "basePath"=>"/",
            "schemes"=>[
              "http"
            ],
            "consumes"=>[
              "application/json"
            ],
            "produces"=>[
              "application/json"
            ],
            "paths"=>{
              "/hello"=>{
                "get"=>{
                  "parameters"=>[

                  ],
                  "responses"=>{
                    "200"=>{
                      "description"=>nil,
                      "schema"=>{
                        "$schema"=>"http://json-schema.org/draft-03/schema#",
                        "type"=>"object",
                        "required"=>true,
                        "properties"=>{
                          "message"=>{
                            "type"=>"string",
                            "required"=>true
                          }
                        }
                      }
                    }
                  },
                  "description"=>nil,
                  "operationId"=>nil,
                  "produces"=>[
                    "application/json"
                  ]
                }
              },
              "/hello_world"=>{
                "get"=>{
                  "parameters"=>[

                  ],
                  "responses"=>{
                    "200"=>{
                      "description"=>nil,
                      "schema"=>{
                        "description"=>"A simple response",
                        "type"=>"object",
                        "properties"=>{
                          "message"=>{
                            "type"=>"string"
                          }
                        }
                      }
                    }
                  },
                  "description"=>nil,
                  "operationId"=>nil,
                  "produces"=>[
                    "application/json"
                  ]
                }
              }
            }
          })
        end
      end
    end
  end
end
