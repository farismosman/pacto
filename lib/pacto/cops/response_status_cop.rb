module Pacto
  module Cops
    class ResponseStatusCop
      def self.investigate(_request, response, contract)
        expected_status = contract.response.status
        actual_status = response.status

        errors = []

        if expected_status.is_a? Array
          if !expected_status.include? actual_status
            errors << "Invalid status: expected one of #{expected_status} but got #{actual_status}"
          end
        else
          if expected_status != actual_status
            errors << "Invalid status: expected #{expected_status} but got #{actual_status}"
          end
        end

        errors
      end
    end
  end
end

Pacto::Cops.register_cop Pacto::Cops::ResponseStatusCop
