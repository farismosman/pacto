module Pacto
  module Swagger
    module Path
      def self.get(contract)
        url = URI.parse(contract["request"]["path"])
        return url.path
      end
    end
  end
end
