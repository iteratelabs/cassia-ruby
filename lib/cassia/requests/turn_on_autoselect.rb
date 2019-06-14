module Cassia
  module Requests
    class TurnOnAutoselect

      def initialize(access_token: nil)
        @access_token = access_token
      end

      def path
        '/api/aps/ap-select-switch'
      end

      def body
        { 'flag' => 1 }.to_json
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
