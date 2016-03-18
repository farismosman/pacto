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
      end
    end
  end
end
