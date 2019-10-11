module Cassia
  module Requests
    class ConnectDevice
      def initialize(access_controller, aps: '*', device_mac: nil)
        @access_controller = access_controller
        @aps = aps
        @device_mac = device_mac
      end

      def path
        '/api/aps/connections/connect'
      end

      def body
        { 'aps' => @aps,
          'devices' => [@device_mac] }.to_json
      end

      def headers
        {
          'Authorization' => "Bearer #{@access_controller.get_token}",
          'Content-Type' => "application/json"
        }
      end

      def perform
        Cassia::ResponseHandlers::ConnectDevice.new(@access_controller).handle(Cassia.api.post(self))
      end
    end
  end
end
