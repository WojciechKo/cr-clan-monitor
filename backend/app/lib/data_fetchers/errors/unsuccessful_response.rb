require 'error'

module DataFetchers
  class Errors
    class UnsuccessfulResponse < Error
      def self.build(response)
        new(error:   :unsuccessful_response,
            message: 'Unsuccessful Response',
            meta:    { response: response })
      end
    end
  end
end
