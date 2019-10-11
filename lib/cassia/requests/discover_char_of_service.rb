module Cassia
  module Requests
    class DiscoverCharOfService
      def initialize(access_controller, router: , device_mac: , service_uuid: )
        @access_controller = access_controller
        @router = router
        @device_mac = device_mac
        @service_uuid = service_uuid
      end

      def path
        "/api/gatt/nodes/#{@device_mac}/services/#{@service_uuid}/characteristics?mac=#{@router.mac}"
      end

      def headers
        {
          'Authorization' => "Bearer #{@access_controller.get_token}",
          'Content-Type' => "application/json"
        }
      end

      def perform
        Cassia::ResponseHandlers::DiscoverCharOfService.new(@access_controller, router: @router, device_mac: @device_mac, service_uuid: @service_uuid).handle(Cassia.api.get(self))
      end
    end
  end
end
