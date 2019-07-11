module Cassia
  module ResponseHandlers
    class DiscoverAll
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
        device = @router.connected_devices.detect {|device| device.mac == @device_mac}
        response.body.each do |service|
          new_service = Service.new(uuid: service["uuid"], primary: service["primary"], handle: service["handle"])
          if !(service["characteristics"].nil?)
            service["characteristics"].each do |char|
              new_char = Characteristic.new(char)
              new_service.characteristics << new_char
              device.characteristics << new_char
            end
          end
          device.services << new_service
        end
      end

      def handle_failure(response)
        @access_controller.error = response.body
      end
    end
  end
end
