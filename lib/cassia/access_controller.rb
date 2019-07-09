module Cassia
  class AccessController
    include Virtus.model

    attribute :access_token, String
    attribute :error, String
    attribute :error_description, String
    attribute :autoselect_switch, Integer, default: 0
    attribute :connected_devices, Array[Cassia::Device], default: []
    attribute :routers, Array[Cassia::Router], default: []
    attribute :sse

    def get_token
      Cassia::Requests::GetToken.new(self).perform
    end

    def get_all_routers_status
      Cassia::Requests::GetAllRoutersStatus.new(self).perform
    end

    def switch_autoselect(flag: )
      Cassia::Requests::SwitchAutoselect.new(self, flag: flag).perform
    end

    def open_scan(aps: , chip: nil, active: nil, filter_name: nil, filter_mac: nil, filter_uuid: nil)
      Cassia::Requests::OpenScan.new(self, aps: aps, chip: chip, active: active, filter_name: filter_name, filter_mac: filter_mac, filter_uuid: filter_uuid).perform
    end

    def close_scan(aps: )
      Cassia::Requests::CloseScan.new(self, aps: aps).perform
    end

    def connect_device(aps: '*', device_mac: )
      Cassia::Requests::ConnectDevice.new(self, aps: aps, device_mac: device_mac).perform
    end

    def disconnect_device(device_mac: )
      Cassia::Requests::DisconnectDevice.new(self, device_mac: device_mac).perform
    end

    def open_notify(aps: )
      Cassia::Requests::OpenNotify.new(self, aps: aps).perform
    end

    def close_notify(aps: )
      Cassia::Requests::CloseNotify.new(self, aps: aps).perform
    end

    def open_connection_state(aps: )
      Cassia::Requests::OpenConnectionState.new(self, aps: aps).perform
    end

    def close_connection_state(aps: )
      Cassia::Requests::CloseConnectionState.new(self, aps: aps).perform
    end

    def open_ap_state
      Cassia::Requests::OpenApState.new(self).perform
    end

    def close_ap_state
      Cassia::Requests::CloseApState.new(self).perform
    end

    def combined_sse
      combined_sse = Cassia::Requests::CombinedSse.new(self)

      self.sse = SSE::Client.new("#{ac_url}#{combined_sse.path}", headers: combined_sse.headers) do |client|
        yield(client)
      end
    end

    private

    def ac_url
      Cassia.configuration.ac_url
    def discover_all_services(router: , device_mac: )
      Cassia::Requests::DiscoverAllServices.new(self, router: router, device_mac: device_mac).perform
    end

    def discover_all_char(router: , device_mac: )
      Cassia::Requests::DiscoverAllChar.new(self, router: router, device_mac: device_mac).perform
    end
  end
end
