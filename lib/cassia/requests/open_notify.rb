module Cassia
  module Requests
    class OpenNotify
      def initialize(access_controller, aps: )
        @access_controller = access_controller
        @aps = aps
      end

      def path
        '/api/aps/notify/open'
      end

      def body
        {
          'aps' => @aps
        }.to_json
      end

      def headers
        {
          'Authorization' => "Bearer #{@access_controller.get_token}",
          'Content-Type' => "application/json"
        }
      end

      def perform
        Cassia::ResponseHandlers::OpenNotify.new(@access_controller, aps: @aps).handle(Cassia.api.post(self))
      end
    end
  end
end
