module Cassia
  module Requests
    class DisconnectDevice
      def initialize(access_controller, device_mac: nil)
        @access_controller = access_controller
        @device_mac = device_mac
      end

      def path
        '/api/aps/connections/disconnect'
      end

      def body
        { 'devices' => [@device_mac] }.to_json
      end

      def headers
        {
          'Authorization' => "Bearer #{@access_controller.get_token}",
          'Content-Type' => "application/json"
        }
      end

      def perform
        Cassia::ResponseHandlers::DisconnectDevice.new(@access_controller).handle(Cassia.api.post(self))
      end
    end
  end
end
