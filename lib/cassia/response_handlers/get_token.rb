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
        @access_controller.access_token = response.body["access_token"]
        # set the token expiration for 3500 seconds from now, the actual expiration is 3600
        # but this gives some buffer
        @access_controller.access_token_expiration = Time.now.getutc + 3500
      end

      def handle_failure(response)
        @access_controller.error = response.body["error"]
        @access_controller.error_description = response.body["error_description"]
      end
    end
  end
end
