module Cassia
  module ResponseHandlers
    class SwitchAutoselect
      def initialize(access_controller)
        @access_controller = access_controller
      end

      def handle(response)
        if response.success?
          handle_success(response)
        else
          handle_failure(response)
        end
        response.success?
      end

      private

      def handle_success(response)
        @access_controller.autoselect_switch = response.body['flag']
      end

      def handle_failure(response)
        @access_controller.error = JSON.parse(response.body)['error']
        @access_controller.error_description = JSON.parse(response.body)['error_description']
      end
    end
  end
end
