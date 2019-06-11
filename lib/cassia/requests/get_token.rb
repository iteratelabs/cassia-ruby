module Cassia
  module Requests
    class GetToken
      def path
        '/oauth2/token'
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
        Cassia.api.post(self)
      end  

      private
      def get_encode
        Base64.encode64("#{Cassia.configuration.client_id}:#{Cassia.configuration.secret}")
      end   
    end 
  end
end