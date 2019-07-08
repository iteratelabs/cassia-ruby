module Cassia
  module Requests
    class CombinedSse
      def initialize(access_controller)
        @access_controller = access_controller
      end

      def path
        "/api/aps/events"
      end

      def headers
        {
          'Authorization' => "Bearer #{access_token}",
          'Content-Type' => "application/json"
        }
      end

      private

      def access_token
        @access_controller.get_token if @access_controller.access_token.nil?
        @access_controller.access_token
      end
    end
  end
end
