require 'hashie/mash'

module Pacto
  class PactoRequest
    # FIXME: Need case insensitive header lookup, but case-sensitive storage
    attr_accessor :headers, :body, :method, :uri, :timeout

    def initialize(data)
      mash = Hashie::Mash.new data
      @headers = mash.headers.nil? ? {} : mash.headers
      @body    = mash.body
      @method  = mash[:method]
      @uri     = mash.uri
      @timeout = mash.timeout
    end

    def parsed_body
      if body.is_a?(String) && content_type == 'application/json'
        JSON.parse(body)
      else
        body
      end
    rescue
      body
    end

    def content_type
      headers['Content-Type']
    end
  end
end
