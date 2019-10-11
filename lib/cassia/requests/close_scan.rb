module Cassia
  module Requests
    class CloseScan
      def initialize(access_controller, aps: )
        @access_controller = access_controller
        @aps = aps
      end

      def path
        '/api/aps/scan/close'
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
        Cassia::ResponseHandlers::CloseScan.new(@access_controller, aps: @aps).handle(Cassia.api.post(self))
      end
    end
  end
end
