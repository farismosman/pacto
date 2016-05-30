module Pacto
  module Swagger
    module Path
      def self.get(contract)
        path = URI.parse(contract["request"]["path"]).path
        swagger = contract['swagger']
        if swagger && swagger['parameters']
          swagger['parameters'].each do |key, value|
            inpath = value['in'] == 'path'
            path = path.sub(key, "{#{value['name']}}") if inpath
          end
        end
        return path
      end
    end
  end
end
