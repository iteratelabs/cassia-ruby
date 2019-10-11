module Cassia
  module Requests
    class SwitchAutoselect

      def initialize(access_controller, flag: 1)
        @access_controller = access_controller
        @flag = flag
      end

      def path
        '/api/aps/ap-select-switch'
      end

      def body
        { 'flag' => @flag }.to_json
      end

      def headers
        {
          'Authorization' => "Bearer #{@access_controller.get_token}",
          'Content-Type' => "application/json"
        }
      end

      def perform
        Cassia::ResponseHandlers::SwitchAutoselect.new(@access_controller).handle(Cassia.api.post(self))
      end
    end
  end
end
