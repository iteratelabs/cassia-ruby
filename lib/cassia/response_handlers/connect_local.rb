module Cassia
  module ResponseHandlers
    class ConnectLocal
      def initialize(access_controller, router: , device_mac: )
        @access_controller = access_controller
        @router = router
        @device_mac = device_mac
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
        new_device = Cassia::Device.new(mac: @device_mac)
        @router.connected_devices << new_device
        @access_controller.connected_devices << new_device
      end

      def handle_failure(response)
        @access_controller.error = response.body
      end
    end
  end
end
