module Cassia
  class AccessController
    include Virtus.model

    attribute :access_token, String
    attribute :error, String
    attribute :error_description, String
    attribute :autoselect_switch, Integer, default: 0
    attribute :connected_devices, Array[Cassia::Device], default: []
    attribute :routers, Array[Cassia::Router], default: []
    attribute :scanning_on, Boolean

    def get_token
      Cassia::Requests::GetToken.new(self).perform
    end

    def get_all_routers_status
      Cassia::Requests::GetAllRoutersStatus.new(self).perform
    end

    def switch_autoselect(flag: )
      Cassia::Requests::SwitchAutoselect.new(self, flag: flag).perform
    end

    def open_scan(aps: nil, chip: nil, active: nil, filter_name: nil, filter_mac: nil, filter_uuid: nil)
      Cassia::Requests::OpenScan.new(self, aps: aps, chip: chip, active: active, filter_name: filter_name, filter_mac: filter_mac, filter_uuid: filter_uuid).perform
    end

    def connect_device(aps: '*', device_mac: )
      Cassia::Requests::ConnectDevice.new(self, aps: aps, device_mac: device_mac).perform
    end
  end
end