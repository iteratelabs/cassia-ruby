module Cassia
  module ResponseHandlers
    class ConnectDevice
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
        @access_controller.device_mac = response.body['device']
      end

      def handle_failure(response)
        @access_controller.error = response.body['error']
      end
    end
  end
end
