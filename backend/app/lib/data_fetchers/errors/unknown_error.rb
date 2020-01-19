require 'error'

module DataFetchers
  class Errors
    class UnknownError < Error
      def self.from_response(response)
        new(error:   :unknown_error,
            message: 'Unknown error',
            meta:    { response: response })
      end

      def self.from_exception(exception)
        new(error:   :unknown_error,
            message: 'Unknown error',
            meta:    { exception: exception })
      end
    end
  end
end
