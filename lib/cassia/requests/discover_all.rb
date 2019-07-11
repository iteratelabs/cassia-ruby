module Cassia
  module Requests
    class DiscoverAll
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
          'Authorization' => "Bearer #{access_token}",
          'Content-Type' => "application/json"
        }
      end

      def perform
        Cassia::ResponseHandlers::DiscoverAll.new(@access_controller, router: @router, device_mac: @device_mac).handle(Cassia.api.get(self))
      end

      private

      def access_token
        @access_controller.get_token if @access_controller.access_token.nil?
        @access_controller.access_token
      end
    end
  end
end
