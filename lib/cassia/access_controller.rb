module Cassia
  class AccessController
    include Virtus.model

    attribute :access_token, String, default: nil
    attribute :error, String, default: nil
    attribute :error_description, String, default: nil
    attribute :autoselect_switch, Integer, default: 0
    attribute :device_mac, String, default: nil

    def get_token
      Cassia::Requests::GetToken.new(self).perform
    end

    def get_all_routers_status
      Cassia::Requests::GetAllRoutersStatus.new(self).perform
    end

    def switch_autoselect
      Cassia::Requests::SwitchAutoselect.new(self).perform
    end

    def open_scan
      Cassia::Requests::OpenScan.new(self).perform
    end

    def connect_device
      Cassia::Requests::ConnectDevice.new(self).perform
    end
  end
end
