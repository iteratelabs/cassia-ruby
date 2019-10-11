module Cassia
  module Requests
    class GetAllRoutersStatus
      attr_reader :access_token

      def initialize(access_controller)
        @access_controller = access_controller
      end

      def path
        '/api/cassia/hubs'
      end

      def headers
        {
          'Authorization' => "Bearer #{@access_controller.get_token}",
          'Content-Type' => "application/json"
        }
      end

      def perform
        Cassia::ResponseHandlers::GetAllRoutersStatus.new(@access_controller).handle(Cassia.api.get(self))
      end
    end
  end
end
