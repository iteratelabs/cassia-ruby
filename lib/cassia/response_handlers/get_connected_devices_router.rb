module Cassia
  module ResponseHandlers
    class GetConnectedDevicesRouter
      def initialize(access_controller, router: )
        @access_controller = access_controller
        @router = router
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
        connected_devices = []
        response.body["nodes"].each do |device|
          new_device = Device.new(device)
          new_device.mac = device.delete("id")
          connected_devices << new_device
        end
        @router.connected_devices = connected_devices
      end

      def handle_failure(response)
        @access_controller.error = response.body
      end
    end
  end
end
