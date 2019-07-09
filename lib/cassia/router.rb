module Cassia
  class Router
    include Virtus.model
    attribute :_id, String
    attribute :id, String
    attribute :mac, String
    attribute :name, String
    attribute :group, String
    attribute :status, String
    attribute :model, String
    attribute :version, String
    attribute :position, String
    attribute :time, Integer
    attribute :ip, String
    attribute :localip, String
    attribute :uptime, Integer
    attribute :offline_time, Integer
    attribute :online_time, Integer
    attribute :update_status, String
    attribute :update_reason, String
    attribute :update_version, String
    attribute :update_progress, Integer
    attribute :container, Hash
    attribute :ap, Hash
    attribute :connected_devices, Array[Cassia::Device], default: []
    attribute :notification_open, Boolean
    attribute :scanning_on, Boolean
    attribute :connection_state_monitor_on, Boolean
    attribute :ap_state_monitor_on, Boolean

    def connect_local(access_controller, device_mac: , type: )
      Cassia::Requests::ConnectLocal.new(access_controller, router: self, device_mac: device_mac, type: type).perform
    end

    def disconnect_local(access_controller, device_mac: )
      Cassia::Requests::DisconnectLocal.new(access_controller, router: self, device_mac: device_mac).perform
    end

    def get_connected_devices(access_controller)
      Cassia::Requests::GetConnectedDevicesRouter.new(access_controller, router: self).perform
    end

    def discover_all_services(access_controller, device_mac: )
      Cassia::Requests::DiscoverAllServices.new(access_controller, router: self, device_mac: device_mac).perform
    end

    def discover_all_char(access_controller, device_mac: )
      Cassia::Requests::DiscoverAllChar.new(access_controller, router: self, device_mac: device_mac).perform
    end
  end
end
