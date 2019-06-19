module Cassia
  module ResponseHandlers
    class GetToken
      def initialize(access_controller)
        @access_controller = access_controller
      end

      def handle(response)
        if response.success?
          handle_success(response)
        else
          handle_failure(response)
        end
        response.success?
      end

      private

      def handle_success(response)
        @access_controller.access_token = response.body['access_token']
        @access_controller.error = nil
        @access_controller.error_description = nil
      end

      def handle_failure(response)
        @access_controller.access_token = nil
        @access_controller.error = response.body['error']
        @access_controller.error_description = response.body['error_description']
      end
    end
  end
end
