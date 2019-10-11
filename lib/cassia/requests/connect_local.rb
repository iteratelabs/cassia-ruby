module Cassia
  module Requests
    class ConnectLocal
      def initialize(access_controller, router: , device_mac: nil, type: 'random', timeout: '5000', auto: '0', discovergatt: '1')
        @access_controller = access_controller
        @router = router
        @device_mac = device_mac
        @type = type
        @timeout = timeout
        @auto = auto
        @discovergatt = discovergatt
      end

      def path
        "/api/gap/nodes/#{@device_mac}/connection?mac=#{@router.mac}"
      end

      def body
        { 'type' => @type,
          'timeout' => @timeout,
          'auto' => @auto,
          'discovergatt' => @discovergatt }.to_json
      end

      def headers
        {
          'Authorization' => "Bearer #{@access_controller.get_token}",
          'Content-Type' => "application/json"
        }
      end

      def perform
        Cassia::ResponseHandlers::ConnectLocal.new(@access_controller, router: @router, device_mac: @device_mac).handle(Cassia.api.post(self))
      end
    end
  end
end
