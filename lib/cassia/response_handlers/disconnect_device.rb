module Cassia
  module ResponseHandlers
    class DisconnectDevice
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
        that_router = @access_controller.connected_devices.find {|router| router['mac'] == response.body['device']}
        @access_controller.connected_devices.delete(that_router)
      end

      def handle_failure(response)
        @access_controller.error = response.body['error']
      end
    end
  end
end
