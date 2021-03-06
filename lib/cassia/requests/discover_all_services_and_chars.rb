module Cassia
  module Requests
    class DiscoverAllServicesAndChars
      def initialize(access_controller, router: , device_mac: )
        @access_controller = access_controller
        @router = router
        @device_mac = device_mac
      end

      def path
        "/api/gatt/nodes/#{@device_mac}/services/characteristics/descriptors?mac=#{@router.mac}"
      end

      def headers
        {
          'Authorization' => "Bearer #{@access_controller.get_token}",
          'Content-Type' => "application/json"
        }
      end

      def perform
        Cassia::ResponseHandlers::DiscoverAllServicesAndChars.new(@access_controller, router: @router, device_mac: @device_mac).handle(Cassia.api.get(self))
      end
    end
  end
end
