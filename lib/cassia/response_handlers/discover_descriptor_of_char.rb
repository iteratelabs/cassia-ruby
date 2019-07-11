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
        device = @router.connected_devices.detect {|device| device.mac == @device_mac}
        char = device.characteristics.detect {|char| char.uuid == @char_uuid}
        if char
          char.descriptors = response.body
        else
          @access_controller.error = "Desciptors Empty. Characteristic Not Found."
        end
        !(response.body.empty?)
      end
    end
  end
end
