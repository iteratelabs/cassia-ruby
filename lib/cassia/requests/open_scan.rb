module Cassia
  module Requests
    class OpenScan
      def initialize(access_controller, aps: , chip: nil, active: nil, filter_name: nil, filter_mac: nil,
        filter_uuid: nil)
        @access_controller = access_controller
        @aps = aps
        @chip = chip
        @active = active
        @filter_name = filter_name
        @filter_mac = filter_mac
        @filter_uuid = filter_uuid
      end

      def path
        '/api/aps/scan/open'
      end

      def body
        body = {
          'aps' => @aps
        }
        body['chip'] = @chip unless @chip.nil?
        body['active'] = @active unless @active.nil?
        body['filter_name'] = @filter_name unless @filter_name.nil?
        body['filter_mac'] = @filter_mac unless @filter_mac.nil?
        body['filter_uuid'] = @filter_uuid unless @filter_uuid.nil?
        body.to_json
      end

      def headers
        {
          'Authorization' => "Bearer #{access_token}",
          'Content-Type' => "application/json"
        }
      end

      def perform
        Cassia::ResponseHandlers::OpenScan.new(@access_controller, aps: @aps).handle(Cassia.api.post(self))
      end

      private

      def access_token
        @access_controller.get_token if @access_controller.access_token.nil?
        @access_controller.access_token
      end
    end
  end
end
