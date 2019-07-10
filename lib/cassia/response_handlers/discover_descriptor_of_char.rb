module Cassia
  module ResponseHandlers
    class DiscoverDescriptorOfChar
      def initialize(access_controller, router: , device_mac: , char_uuid: )
        @access_controller = access_controller
        @router = router
        @device_mac = device_mac
        @char_uuid = char_uuid
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
        device = @router.connected_devices.detect {|device| device.mac == @device_mac}
        device = Device.new(mac: @device_mac) if device.nil?
        char = device.characteristics.detect {|char| char.uuid == @char_uuid}
        char = Characteristic.new(uuid: @char_uuid) if char.nil?
        char.descriptors = response.body
      end

      def handle_failure(response)
        @access_controller.error = response.body
      end
    end
  end
end
