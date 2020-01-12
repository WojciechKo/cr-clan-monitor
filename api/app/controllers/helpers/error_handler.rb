module Helpers
  module ErrorHandler
    def self.included(clazz)
      clazz.class_eval do
        rescue_from ApiError do |e|
          response = {
            error:   e.error,
            message: e.message
          }

          render_json(response, e.status)
        end
      end
    end

    private

    def render_json(response, status)
      render(json: response.as_json, status: status)
    end
  end
end
