module Pacto
  class URI
    def self.for(host, path, params = {})
      Addressable::URI.heuristic_parse("#{host}#{path}").tap do |uri|
        uri.query_values = params unless params.nil? || params.empty?
      end
    end

    def self.parse(url)
      return Addressable::URI.parse(url)
    end
  end
end
