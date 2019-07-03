module Cassia
  module ResponseHandlers
    class OpenScan
      def initialize(access_controller, aps: )
        @access_controller = access_controller
        @aps = aps
      end

      def handle(response)
        if response.success?
          handle_success
        else
          handle_failure(response)
        end
        response.success?
      end

      private

      def handle_success
        routers_to_open_scan = @access_controller.routers.select {|router| @aps.include?(router.mac) }
        routers_to_open_scan.each do |router|
          router.scanning_on = true
        end
      end

      def handle_failure(response)
        @access_controller.error = JSON.parse(response.body)['error']
      end
    end
  end
end
