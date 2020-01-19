module Helpers
  class ApiError < StandardError
    attr_reader :status, :error, :message

    def initialize(status = nil, error = nil, message = nil)
      @status  = status || 422
      @error   = error || :unprocessable_entity
      @message = message || 'Something went wrong'
    end

    class NotFound < ApiError
      def initialize
        super(404, :not_found, 'Not found')
      end
    end
  end
end
