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
          'Authorization' => "Bearer #{@access_controller.get_token}",
          'Content-Type' => "application/json"
        }
      end
    end
  end
end
