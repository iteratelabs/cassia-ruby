module Cassia
  module Requests
    class GetToken
      def initialize(access_controller)
        @access_controller = access_controller
      end

      def path
        '/api/oauth2/token'
      end

      def body
        { 'grant_type' => "client_credentials" }.to_json
      end

      def headers
        {
          'Authorization' => "Basic #{get_encode}",
          'Content-Type' => "application/json"
        }
      end

      def perform
        Cassia::ResponseHandlers::GetToken.new(@access_controller).handle(Cassia.api.post(self))
      end

      private

      def get_encode
        Base64.encode64("#{Cassia.configuration.client_id}:#{Cassia.configuration.secret}").strip
      end
    end
  end
end
