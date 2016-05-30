module Pacto
  module Swagger
    module Parameters
      describe 'Parameters' do
        describe 'URL' do
          user_id = {
            "name" => "userId",
            "in" => "path",
            "description" => "The user id",
            "required" => true,
            "type" => "string"
          }

          type = {
            "in" => "query",
            "description" => "The type",
            "required" => false,
            "type" => "string"
          }

          it 'should build swagger query parameters from contract' do
            path = 'www.host.com/users?name=dude'
            parameters = {
              'name' => {
                "in" => "query",
                "description" => "The customer name",
                "required" => true,
                "type" => "string"
              }
            }

            param = Pacto::Swagger::Parameters.build(path, {}, parameters)

            expect(param).to eq([{
              "name" => "name",
              "in" => "query",
              "description" => "The customer name",
              "required" => true,
              "type" => "string"
            }])
          end

          it 'should build swagger query parameters from multiple parameters' do
            path = 'www.host.com/users?name=dude&age=10'
            parameters = {
              'name' => {
                "in" => "query",
                "description" => "The customer name",
                "required" => true,
                "type" => "string"
              },
              'age' => {
                "in" => "query",
                "description" => "The customer age",
                "required" => false,
                "type" => "integer"
              }
            }

            param = Pacto::Swagger::Parameters.build(path, {}, parameters)

            expect(param).to eq([
              {
                "name" => "name",
                "in" => "query",
                "description" => "The customer name",
                "required" => true,
                "type" => "string"
              },
              {
                "name" => "age",
                "in" => "query",
                "description" => "The customer age",
                "required" => false,
                "type" => "integer"
              }
            ])
          end

          it 'should build swagger path parameters from contract' do
            path = 'www.host.com/users/12fs-32gt6'
            parameters = {'12fs-32gt6' => user_id}

            param = Pacto::Swagger::Parameters.build(path, {}, parameters)

            expect(param).to eq([user_id])
          end

          it 'should build swagger query and path parameters from contract' do
            path = 'www.host.com/users/12fs-32gt6?type=id'
            parameters = {
              '12fs-32gt6' => user_id,
              'type' => type
            }

            param = Pacto::Swagger::Parameters.build(path, {}, parameters)

            expect(param.include?(user_id)).to eq(true)

            expect(param.include?({
              "name" => "type",
              "in" => "query",
              "description" => "The type",
              "required" => false,
              "type" => "string"
            })).to eq(true)
          end

          it 'should build swagger from contract when no parameters' do
            path = 'www.host.com/users'
            parameters = {}

            param = Pacto::Swagger::Parameters.build(path, {}, parameters)

            expect(param).to eq([])
          end

        end
      end
    end
  end
end
