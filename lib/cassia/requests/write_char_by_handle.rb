module Cassia
  module Requests
    class WriteCharByHandle
      def initialize(access_controller, router: , device_mac: , handle: , value: )
        @access_controller = access_controller
        @router = router
        @device_mac = device_mac
        @handle = handle
        @value = value
      end

      def path
        "/api/gatt/nodes/#{@device_mac}/handle/#{@handle}/value/#{@value}?mac=#{@router.mac}"
      end

      def headers
        {
          'Authorization' => "Bearer #{access_token}",
          'Content-Type' => "application/json"
        }
      end

      def perform
        Cassia::ResponseHandlers::WriteCharByHandle.new(@access_controller, router: @router, device_mac: @device_mac, handle: @handle, value: @value).handle(Cassia.api.get(self))
      end

      private

      def access_token
        @access_controller.get_token if @access_controller.access_token.nil?
        @access_controller.access_token
      end
    end
  end
end
