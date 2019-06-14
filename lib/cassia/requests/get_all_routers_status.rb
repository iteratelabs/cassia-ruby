module Cassia
  module Requests
    class GetAllRoutersStatus
      attr_reader :access_token

      def initialize(access_token: nil)
        @access_token = access_token
      end

      def path
        '/api/cassia/hubs'
      end

      def headers
        {
          'Authorization' => "Bearer #{access_token}",
          'Content-Type' => "application/json"
        }
      end

      def perform
        Cassia.api.get(self)
      end

      private

      def access_token
        @access_token ||= Cassia::Requests::GetToken.new.perform().body["access_token"]
      end
    end
  end
end
