module Cassia
  module Requests
    class GetConnectedDevicesRouter
      attr_reader :access_token

      def initialize(access_controller, router: )
        @access_controller = access_controller
        @router = router
      end

      def path
        "/api/gap/nodes?connection_state=connected&mac=#{@router.mac}"
      end

      def headers
        {
          'Authorization' => "Bearer #{@access_controller.get_token}",
          'Content-Type' => "application/json"
        }
      end

      def perform
        Cassia::ResponseHandlers::GetConnectedDevicesRouter.new(@access_controller, router: @router).handle(Cassia.api.get(self))
      end
    end
  end
end
