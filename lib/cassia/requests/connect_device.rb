module Cassia
  module Requests
    class ConnectDevice

      def initialize(access_token: nil, aps: '*', mac: nil)
        @access_token = access_token  
        @aps = aps
        @mac = mac
      end

      def path
        '/api/aps/connections/connect'
      end

      def body
        { 'aps' => @aps,
          'devices' => [@mac] }.to_json
      end

      def headers
        {
          'Authorization' => "Bearer #{access_token}",
          'Content-Type' => "application/json"
        }
      end

      def perform
        Cassia.api.post(self)
      end

      private

      def access_token
        @access_token ||= Cassia::Requests::GetToken.new.perform().body["access_token"]
      end

    end
  end
end
