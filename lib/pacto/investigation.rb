module Pacto
  class Investigation
    include Logger
    attr_reader :request, :response, :contract, :citations

    def initialize(request, response, contract = nil, citations = nil)
      @request = request
      @response = response
      @contract = contract
      @citations = citations || []
    end

    def successful?
      @citations.empty?
    end

    def against_contract?(contract_pattern)
      return nil if @contract.nil?

      case contract_pattern
      when String
        @contract if @contract.file.eql? contract_pattern
      when Regexp
        @contract if @contract.file =~ contract_pattern
      end
    end

    def to_s
      contract_name = @contract.nil? ? 'nil' : contract.name
      ''"
      Investigation:
      \tRequest: #{@request}
      \tContract: #{contract_name}
      \tCitations: \n\t\t#{@citations.join "\n\t\t"}
      "''
    end

    def summary
      if @contract.nil?
        "Missing contract for services provided by #{@request.uri.host}"
      else
        status = successful? ? 'successful' : 'unsuccessful'
        summary = "#{status} investigation of #{@contract.name}"
        summary = summary + "\n" + "\tCitations: \n\t\t#{@citations.join "\n\t\t"}" unless successful?
        summary
      end
    end
  end
end
