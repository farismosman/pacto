module Pacto
  module Swagger
    module Path
      describe 'path' do
        it 'should get path from contract' do
          config = {
            "request" => {
              "path" => "/user/12dds24-34dsas"
            }
          }

          path = Pacto::Swagger::Path.get(config)

          expect(path).to eq("/user/12dds24-34dsas")
        end

        it 'should get path from contract and replace id with variable {id}' do
          contract = {
            "request" => {
              "path" => "/user/12dds24-34dsas"
            },
            "swagger" => {
              "parameters" => {
                "12dds24-34dsas" => {
                  "name" => "userId",
                  "in" => "path",
                  "description" => "The DB customer Id",
                  "required" => true,
                  "type" => "string"
                }
              }
            }
          }

          path = Pacto::Swagger::Path.get(contract)

          expect(path).to eq("/user/{userId}")
        end

        it 'should not get path from contract when is not defined in swagger parameters' do
          contract = {
            "request" => {
              "path" => "/user/12dds24-34dsas"
            },
            "swagger" => {
              "parameters" => {
                "idDoesNotExist" => {
                  "name" => "userId",
                  "in" => "path",
                  "description" => "The DB customer Id",
                  "required" => true,
                  "type" => "string"
                }
              }
            }
          }

          path = Pacto::Swagger::Path.get(contract)

          expect(path).to eq("/user/12dds24-34dsas")
        end

        it 'should not get path from contract when is not in path' do
          contract = {
            "request" => {
              "path" => "/user/12dds24-34dsas"
            },
            "swagger" => {
              "parameters" => {
                "12dds24-34dsas" => {
                  "name" => "userId",
                  "in" => "query",
                  "description" => "The DB customer Id",
                  "required" => true,
                  "type" => "string"
                }
              }
            }
          }

          path = Pacto::Swagger::Path.get(contract)

          expect(path).to eq("/user/12dds24-34dsas")
        end

        it 'should replace multiple path parameters' do
          contract = {
            "request" => {
              "path" => "/customer/status/12dds24-34dsas/"
            },
            "swagger" => {
              "parameters" => {
                "12dds24-34dsas" => {
                  "name" => "userId",
                  "in" => "path",
                  "description" => "The DB customer Id",
                  "required" => true,
                  "type" => "string"
                },
                "status" => {
                  "name" => "product",
                  "in" => "path",
                  "description" => "The customer Id",
                  "required" => true,
                  "type" => "string"
                }
              }
            }
          }

          path = Pacto::Swagger::Path.get(contract)

          expect(path).to eq("/customer/{product}/{userId}/")
        end
      end
    end
  end
end
