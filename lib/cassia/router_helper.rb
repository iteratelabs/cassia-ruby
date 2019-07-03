module Cassia
  class RouterHelper
    def get_routers(routers, aps)
      return routers if aps == '*'
      routers.select { |router| aps.include?(router.mac) }
    end
  end
end
