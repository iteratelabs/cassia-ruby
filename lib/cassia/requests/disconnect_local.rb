module Cassia
  module Requests
    class DisconnectLocal
      def initialize(access_controller, router: , device_mac: )
        @access_controller = access_controller
        @router = router
        @device_mac = device_mac
      end

      def path
        "/api/gap/nodes/#{@device_mac}/connection?mac=#{@router.mac}"
      end

      def headers
        {
          'Authorization' => "Bearer #{@access_controller.get_token}",
          'Content-Type' => "application/json"
        }
      end

      def perform
        Cassia::ResponseHandlers::DisconnectLocal.new(@access_controller, router: @router, device_mac: @device_mac).handle(Cassia.api.delete(self))
      end
    end
  end
end
