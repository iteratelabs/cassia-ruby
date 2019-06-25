module Cassia
  module ResponseHandlers
    class GetAllRoutersStatus
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
        response.body.each do |router|
          new_router = Router.new
          new_router._id = router["_id"]
          new_router.id = router["id"]
          new_router.mac = router["mac"]
          new_router.name = router["name"]
          new_router.group = router["group"]
          new_router.status = router["status"]
          new_router.model = router["model"]
          new_router.version = router["version"]
          new_router.position = router["position"]
          new_router.time = router["time"]
          new_router.ip = router["ip"]
          new_router.localip = router["localip"]
          new_router.uptime = router["uptime"]
          new_router.offline_time = router["offline_time"]
          new_router.online_time = router["online_time"]
          new_router.update_status = router["update_status"]
          new_router.update_reason = router["update_reason"]
          new_router.update_version = router["update_version"]
          new_router.update_progress = router["update_progress"]
          new_router.container = router["container"]
          new_router.ap = router["ap"]
          @access_controller.routers.append(new_router)
        end
      end

      def handle_failure(response)
        @access_controller.error = JSON.parse(response.body)["error"]
        @access_controller.error_description = JSON.parse(response.body)["error_description"]
      end
    end
  end
end
