module Cassia
  module ResponseHandlers
    class DiscoverCharOneService
      def initialize(access_controller, router: , device_mac: , service_uuid: )
        @access_controller = access_controller
        @router = router
        @device_mac = device_mac
        @service_uuid = service_uuid
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
        device = @router.connected_devices.select {|device| device.mac == @device_mac}[0]
        service = device.services.select {|service| service.uuid == @service_uuid}[0]
        response.body.each do |char|
          new_char = Characteristic.new(char)
          service.characteristics << new_char
          device.characteristics << new_char
        end
      end

      def handle_failure(response)
        @access_controller.error = response.body
      end
    end
  end
end
