module Cassia
  module Requests
    class OpenApState
      def initialize(access_controller)
        @access_controller = access_controller
      end

      def path
        '/api/aps/ap-state/open'
      end

      def headers
        {
          'Authorization' => "Bearer #{@access_controller.get_token}",
          'Content-Type' => "application/json"
        }
      end

      def perform
        Cassia::ResponseHandlers::OpenApState.new(@access_controller).handle(Cassia.api.get(self))
      end
    end
  end
end
