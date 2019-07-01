module Cassia
  module ResponseHandlers
    class OpenNotify
      def initialize(access_controller, aps: )
        @access_controller = access_controller
        @aps = aps
      end

      def handle(response)
        if response.success?
          handle_success
        else
          handle_failure(response)
        end
        response.success?
      end

      private

      def handle_success
        @aps.each do |router|
          router.notification_on = true
        end
      end

      def handle_failure(response)
        puts response.body
        puts response.body.class
        # @access_controller.error = JSON.parse(response.body)['error']
      end
    end
  end
end
