module Cassia
  module ResponseHandlers
    class WriteCharByHandle
      def initialize(access_controller, router: , device_mac: , handle: , value: )
        @access_controller = access_controller
        @router = router
        @device_mac = device_mac
        @handle = handle
        @value = value
      end

      def handle(response)
        device = @router.connected_devices.detect {|device| device.mac == @device_mac}
        char = device.characteristics.detect {|char| char.handle == @handle}
        if char
          if @value == "0100"
            char.notification_on = true
          elsif @value == "0000"
            char.notification_on = false
          end
        else
          @access_controller.error = "Characteristic With Given Handle Not Found"
        end
        !(char.nil?)
      end
    end
  end
end
