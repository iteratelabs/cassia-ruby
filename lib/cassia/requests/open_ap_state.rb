module Cassia
  module Requests
    class OpenAPState
      def initialize(access_controller)
        @access_controller = access_controller
      end

      def path
        '/api/aps/ap-state/open'
      end

      def headers
        {
          'Authorization' => "Bearer #{access_token}",
          'Content-Type' => "application/json"
        }
      end

      def perform
        Cassia::ResponseHandlers::OpenAPState.new(@access_controller).handle(Cassia.api.get(self))
      end

      private

      def access_token
        @access_controller.get_token if @access_controller.access_token.nil?
        @access_controller.access_token
      end
    end
  end
end
