require 'spec_helper'

RSpec.describe Cassia::AccessController do
  include FaradayHelpers
  include EnvironmentHelpers

  describe "#get_token" do
    vcr_options = { cassette_name: 'access_controller/get_token/success', record: :new_episodes }
    context "when successful", vcr: vcr_options do
      it "sets the access_token" do
        access_controller = described_class.new

        access_controller.get_token

        expect(access_controller.access_token).not_to be_nil
      end
    end

    context "when the token is expired", vcr: vcr_options do
      it "gets a new access_token" do
        access_controller = described_class.new(access_token: 'old_token', access_token_expiration: Time.now.getutc - 30)

        access_controller.get_token

        expect(access_controller.access_token).not_to eq('old_token')
      end
    end

    context "when the token is not expired and already exists" do
      it "returns the current token" do
        access_controller = described_class.new(access_token: 'current_token', access_token_expiration: Time.now.getutc + 1000)

        access_controller.get_token

        expect(access_controller.access_token).to eq('current_token')
      end
    end

    vcr_options = { cassette_name: 'access_controller/get_token/failure', record: :new_episodes }
    context "when unsuccessful", vcr: vcr_options do
      it "sets the error and error_description values" do
        with_environment('CASSIA_CLIENT_ID' => 'invalid', 'CASSIA_SECRET' => 'invalid') do
          access_controller = described_class.new

          access_controller.get_token

          expect(access_controller.error). to eq "invalid_client"
          expect(access_controller.error_description). to eq "Client not found"
        end
      end
    end
  end

  describe "#get_all_routers_status" do
    vcr_options = { cassette_name: 'access_controller/routersstatus/success', record: :new_episodes }
    context "when successful", vcr: vcr_options do
      it "appends routers to the array" do
        access_controller = described_class.new

        access_controller.get_all_routers_status

        expect(access_controller.routers).not_to be_empty
      end
    end

    vcr_options = { cassette_name: 'access_controller/routersstatus/failure', record: :new_episodes }
    context "when unsuccessful", vcr: vcr_options do
      it "sets the error and error_description values" do
        with_environment('CASSIA_CLIENT_ID' => 'invalid', 'CASSIA_SECRET' => 'invalid') do
          access_controller = described_class.new

          access_controller.get_all_routers_status

          expect(access_controller.error). to eq "access_denied"
          expect(access_controller.error_description). to eq "Wrong authorization header"
        end
      end
    end
  end

  describe "#switch_autoselect" do
    vcr_options = { cassette_name: 'access_controller/switch_autoselect/success_1', record: :new_episodes }
    context "when successfully switching to 1", vcr: vcr_options do
      it "sets the switch to 1" do
        access_controller = described_class.new

        access_controller.switch_autoselect(flag: 1)

        expect(access_controller.autoselect_switch).to eq 1
      end
    end

    vcr_options = { cassette_name: 'access_controller/switch_autoselect/success_0', record: :new_episodes }
    context "when successfully switching to 0", vcr: vcr_options do
      it "sets the switch to 0" do
        access_controller = described_class.new

        access_controller.switch_autoselect(flag: 0)

        expect(access_controller.autoselect_switch).to eq 0
      end
    end

    vcr_options = { cassette_name: 'access_controller/switch_autoselect/failure', record: :new_episodes }
    context "when unsuccessful", vcr: vcr_options do
      it "sets the error and error_description values" do
        with_environment('CASSIA_CLIENT_ID' => 'invalid', 'CASSIA_SECRET' => 'invalid') do
          access_controller = described_class.new

          access_controller.switch_autoselect(flag: 0)

          expect(access_controller.error). to eq "access_denied"
          expect(access_controller.error_description). to eq "Wrong authorization header"
        end
      end
    end
  end

  describe "#open_scan" do
    vcr_options = { cassette_name: 'access_controller/open_scan/failure', record: :new_episodes }
    context "when unsuccessful", vcr: vcr_options do
      it "sets the error" do
        access_controller = described_class.new

        access_controller.open_scan(aps: ["invalid router mac"])

        expect(access_controller.error). to eq "invalid aps"
      end
    end
  end

  describe "#connect_device" do
    vcr_options = { cassette_name: 'access_controller/connect_device/success', record: :new_episodes }
    context "when successful", vcr: vcr_options do
      it "sets the device mac address" do
        access_controller = described_class.new

        access_controller.open_scan(aps: ["CC:1B:E0:E0:F1:E8"])
        access_controller.connect_device(device_mac: "F3:25:5F:22:35:39")

        expect(access_controller.connected_devices).not_to be_empty
      end
    end

    vcr_options = { cassette_name: 'access_controller/connect_device/failure', record: :new_episodes }
    context "when unsuccessful" do
      it "sets the error", vcr: vcr_options do
        access_controller = described_class.new

        access_controller.connect_device(device_mac: ["blah"])

        expect(access_controller.error). to eq "invalid devices"
      end
    end
  end

  describe "#disconnect_device" do
    vcr_options = { cassette_name: 'access_controller/disconnect_device/success', record: :new_episodes }
    context "when successful", vcr: vcr_options do
      it "removes the device from connected_devices" do
        access_controller = described_class.new

        access_controller.open_scan(aps: ["CC:1B:E0:E0:F1:E8"])
        access_controller.connect_device(device_mac: "F3:25:5F:22:35:39")
        access_controller.disconnect_device(device_mac: "F3:25:5F:22:35:39")

        expect(access_controller.connected_devices).to be_empty
      end
    end

    vcr_options = { cassette_name: 'access_controller/disconnect_device/failure', record: :new_episodes }
    context "when unsuccessful" do
      it "sets the error", vcr: vcr_options do
        access_controller = described_class.new

        access_controller.open_scan(aps: ["CC:1B:E0:E0:F1:E8"])
        access_controller.connect_device(device_mac: "F3:25:5F:22:35:39")
        access_controller.disconnect_device(device_mac: "invalid device mac")

        expect(access_controller.error). to eq "invalid devices"
      end
    end
  end

  describe "#open_notify" do
    vcr_options = { cassette_name: 'access_controller/open_notify/failure', record: :new_episodes }
    context "when unsuccessful", vcr: vcr_options do
      it "sets the error" do
        access_controller = described_class.new

        access_controller.open_notify(aps: ["invalid router mac"])

        expect(access_controller.error). to eq "invalid aps"
      end
    end
  end

  describe "#close_notify" do
    vcr_options = { cassette_name: 'access_controller/close_notify/failure', record: :new_episodes }
    context "when unsuccessful", vcr: vcr_options do
      it "sets the error" do
        access_controller = described_class.new

        access_controller.close_notify(aps: ["invalid router mac"])

        expect(access_controller.error). to eq "invalid aps"
      end
    end
  end

  describe "#close_scan" do
    vcr_options = { cassette_name: 'access_controller/close_scan/failure', record: :new_episodes }
    context "when unsuccessful", vcr: vcr_options do
      it "sets the error" do
        access_controller = described_class.new

        access_controller.close_notify(aps: ["invalid router mac"])

        expect(access_controller.error). to eq "invalid aps"
      end
    end
  end

  describe "#open_connection_state" do
    vcr_options = { cassette_name: 'access_controller/open_connection_state/failure', record: :new_episodes }
    context "when unsuccessful", vcr: vcr_options do
      it "sets the error" do
        access_controller = described_class.new

        access_controller.close_notify(aps: ["invalid router mac"])

        expect(access_controller.error). to eq "invalid aps"
      end
    end
  end

  describe "#close_connection_state" do
    vcr_options = { cassette_name: 'access_controller/close_connection_state/failure', record: :new_episodes }
    context "when unsuccessful", vcr: vcr_options do
      it "sets the error" do
        access_controller = described_class.new

        access_controller.close_notify(aps: ["invalid router mac"])

        expect(access_controller.error). to eq "invalid aps"
      end
    end
  end

  describe "#open_ap_state" do
    vcr_options = { cassette_name: 'access_controller/open_ap_state/success', record: :new_episodes }
    context "when successful", vcr: vcr_options do
      it "turns on ap_state_monitor_on for all routers" do
        access_controller = described_class.new

        access_controller.open_ap_state

        access_controller.routers.each do |router|
          expect(router.ap_state_monitor_on).to be_truthy
        end
      end
    end

    vcr_options = { cassette_name: 'access_controller/open_ap_state/failure', record: :new_episodes }
    context "when unsuccessful" do
      it "sets the error", vcr: vcr_options do
        with_environment('CASSIA_CLIENT_ID' => 'invalid client id', 'CASSIA_SECRET' => 'invalid secret') do
          access_controller = described_class.new

          access_controller.open_ap_state

          expect(access_controller.error). to eq "access_denied"
          expect(access_controller.error_description).to eq "Wrong authorization header"
        end
      end
    end
  end

  describe "#open_ap_state" do
    vcr_options = { cassette_name: 'access_controller/close_ap_state/success', record: :new_episodes }
    context "when successful", vcr: vcr_options do
      it "turns on ap_state_monitor_on for all routers" do
        access_controller = described_class.new

        access_controller.close_ap_state

        access_controller.routers.each do |router|
          expect(router.ap_state_monitor_on).to be_falsey
        end
      end
    end

    vcr_options = { cassette_name: 'access_controller/close_ap_state/failure', record: :new_episodes }
    context "when unsuccessful" do
      it "sets the error", vcr: vcr_options do
        with_environment('CASSIA_CLIENT_ID' => 'invalid client id', 'CASSIA_SECRET' => 'invalid secret') do
          access_controller = described_class.new

          access_controller.close_ap_state

          expect(access_controller.error). to eq "access_denied"
          expect(access_controller.error_description).to eq "Wrong authorization header"
        end
      end
    end
  end

  describe "#combined_sse" do
    vcr_options = { cassette_name: 'access_controller/combined_sse/success', record: :new_episodes }
    context "when successful" do
      it "takes the body and yields it", vcr: vcr_options do
        access_controller = described_class.new

        access_controller.combined_sse do |client|
          client.close
        end

        expect(access_controller.sse).not_to be_nil
      end
    end
  end

  describe "#discover_all_services" do
    vcr_options = { cassette_name: 'access_controller/discover_all_services/success', record: :new_episodes }
      context "when successful", vcr: vcr_options do
        it "sets the services for a router" do
          access_controller = described_class.new
          router = Cassia::Router.new(mac: "CC:1B:E0:E0:F1:E8")
          connect_req = Cassia::Requests::ConnectLocal.new(access_controller, router: router, device_mac: "F6:12:3D:BD:DE:44", type: "random")
          connect_res = connect_req.perform

          access_controller.discover_all_services(router: router, device_mac: "F6:12:3D:BD:DE:44")

          service1 = Cassia::Service.new(handle: 1, primary: true, uuid: "00001800-0000-1000-8000-00805f9b34fb")
          service2 = Cassia::Service.new(handle: 10, primary: true, uuid: "00001801-0000-1000-8000-00805f9b34fb")
          service3 = Cassia::Service.new(handle: 11, primary: true, uuid: "6e400001-b5a3-f393-e0a9-e50e24dcca9e")

          expect(access_controller.connected_devices.first.services).to eq([service1, service2, service3])
        end
      end

    vcr_options = { cassette_name: 'access_controller/discover_all_services/failure', record: :new_episodes }
      context "when unsuccessful" do
        it "sets the error", vcr: vcr_options do
          access_controller = described_class.new
          router = Cassia::Router.new(mac: "CC:1B:E0:E0:F1:E8")
          connect_req = Cassia::Requests::ConnectLocal.new(access_controller, router: router, device_mac: "F6:12:3D:BD:DE:44", type: "random")
          connect_res = connect_req.perform

          access_controller.discover_all_services(router: router, device_mac: "F6:12:3D:BD:DE:40")

          expect(access_controller.error). to eq "device disconnect"
        end
      end
  end

  describe "#discover_all_char" do
  vcr_options = { cassette_name: 'access_controller/discover_all_char/success', record: :new_episodes }
    context "when successful", vcr: vcr_options do
      it "sets the characteristics for a router" do
        access_controller = described_class.new
        router = Cassia::Router.new(mac: "CC:1B:E0:E0:F1:E8")
        connect_req = Cassia::Requests::ConnectLocal.new(access_controller, router: router, device_mac: "F6:12:3D:BD:DE:44", type: "random")
        connect_res = connect_req.perform

        access_controller.discover_all_char(router: router, device_mac: "F6:12:3D:BD:DE:44")

        char1 = Cassia::Characteristic.new(uuid: "00002a00-0000-1000-8000-00805f9b34fb", handle: 3, properties: 10)
        char2 = Cassia::Characteristic.new(uuid: "00002a01-0000-1000-8000-00805f9b34fb", handle: 5, properties: 2)
        char3 = Cassia::Characteristic.new(uuid: "00002a04-0000-1000-8000-00805f9b34fb", handle: 7, properties: 2)
        char4 = Cassia::Characteristic.new(uuid: "00002aa6-0000-1000-8000-00805f9b34fb", handle: 9, properties: 2)
        char5 = Cassia::Characteristic.new(uuid: "6e400003-b5a3-f393-e0a9-e50e24dcca9e", handle: 13, properties: 16)
        char6 = Cassia::Characteristic.new(uuid: "6e400002-b5a3-f393-e0a9-e50e24dcca9e", handle: 16, properties: 12)

        expect(access_controller.connected_devices.first.characteristics).to eq [char1, char2, char3, char4, char5, char6]
      end
    end

  vcr_options = { cassette_name: 'access_controller/discover_all_char/failure', record: :new_episodes }
    context "when unsuccessful" do
      it "sets the error", vcr: vcr_options do
        access_controller = described_class.new
        router = Cassia::Router.new(mac: "CC:1B:E0:E0:F1:E8")
        connect_req = Cassia::Requests::ConnectLocal.new(access_controller, router: router, device_mac: "F6:12:3D:BD:DE:44", type: "random")
        connect_res = connect_req.perform

        access_controller.discover_all_char(router: router, device_mac: "F6:12:3D:BD:DE:40")

        expect(access_controller.error). to eq "device disconnect"
      end
    end
  end

  describe "#discover_char_of_service" do
  vcr_options = { cassette_name: 'access_controller/discover_char_of_service/success', record: :new_episodes }
    context "when successful", vcr: vcr_options do
      it "sets the characteristics for a service" do
        access_controller = described_class.new
        router = Cassia::Router.new(mac: "CC:1B:E0:E0:F1:E8")
        connect_req = Cassia::Requests::ConnectLocal.new(access_controller, router: router, device_mac: "F6:12:3D:BD:DE:44", type: "random")
        connect_res = connect_req.perform
        service_req = Cassia::Requests::DiscoverAllServices.new(access_controller, router: router, device_mac: "F6:12:3D:BD:DE:44")
        service_res = service_req.perform

        access_controller.discover_char_of_service(router: router, device_mac: "F6:12:3D:BD:DE:44", service_uuid: "00001800-0000-1000-8000-00805f9b34fb")

        char1 = Cassia::Characteristic.new(uuid: "00002a00-0000-1000-8000-00805f9b34fb", handle: 3, properties: 10)
        char2 = Cassia::Characteristic.new(uuid: "00002a01-0000-1000-8000-00805f9b34fb", handle: 5, properties: 2)
        char3 = Cassia::Characteristic.new(uuid: "00002a04-0000-1000-8000-00805f9b34fb", handle: 7, properties: 2)
        char4 = Cassia::Characteristic.new(uuid: "00002aa6-0000-1000-8000-00805f9b34fb", handle: 9, properties: 2)

        expect(access_controller.connected_devices.first.characteristics).to eq [char1, char2, char3, char4]
      end
    end

  vcr_options = { cassette_name: 'access_controller/discover_char_of_service/failure', record: :new_episodes }
    context "when unsuccessful" do
      it "sets the error", vcr: vcr_options do
        access_controller = described_class.new
        router = Cassia::Router.new(mac: "CC:1B:E0:E0:F1:E8")
        connect_req = Cassia::Requests::ConnectLocal.new(access_controller, router: router, device_mac: "F6:12:3D:BD:DE:44", type: "random")
        connect_res = connect_req.perform
        service_req = Cassia::Requests::DiscoverAllServices.new(access_controller, router: router, device_mac: "F6:12:3D:BD:DE:44")
        service_res = service_req.perform

        access_controller.discover_char_of_service(router: router, device_mac: "F6:12:3D:BD:DE:44", service_uuid: "11001800-0000-1000-8000-00805f9b34fb")

        expect(access_controller.error). to eq "Service Not Found"
      end
    end
  end

  describe "#discover_descriptor_of_char" do
  vcr_options = { cassette_name: 'access_controller/discover_descriptor_of_char/success', record: :new_episodes }
    context "when successful", vcr: vcr_options do
      it "sets the descriptors of a characteristic" do
        access_controller = described_class.new
        router = Cassia::Router.new(mac: "CC:1B:E0:E0:F1:E8")
        connect_req = Cassia::Requests::ConnectLocal.new(access_controller, router: router, device_mac: "F6:12:3D:BD:DE:44", type: "random")
        connect_res = connect_req.perform
        char_req = Cassia::Requests::DiscoverAllChar.new(access_controller, router: router, device_mac: "F6:12:3D:BD:DE:44")
        char_res = char_req.perform

        access_controller.discover_descriptor_of_char(router: router, device_mac: "F6:12:3D:BD:DE:44", char_uuid: "00002a00-0000-1000-8000-00805f9b34fb")

        char = access_controller.connected_devices.first.characteristics.detect {|char| char.uuid == "00002a00-0000-1000-8000-00805f9b34fb"}
        descriptor = Cassia::Descriptor.new(handle: 3, uuid: "00002a00-0000-1000-8000-00805f9b34fb")
        expect(char.descriptors).to eq [descriptor]
      end
    end

  vcr_options = { cassette_name: 'access_controller/discover_descriptor_of_char/failure', record: :new_episodes }
    context "when unsuccessful" do
      it "sets the error", vcr: vcr_options do
        access_controller = described_class.new
        router = Cassia::Router.new(mac: "CC:1B:E0:E0:F1:E8")
        connect_req = Cassia::Requests::ConnectLocal.new(access_controller, router: router, device_mac: "F6:12:3D:BD:DE:44", type: "random")
        connect_res = connect_req.perform
        char_req = Cassia::Requests::DiscoverAllChar.new(access_controller, router: router, device_mac: "F6:12:3D:BD:DE:44")
        char_res = char_req.perform

        access_controller.discover_descriptor_of_char(router: router, device_mac: "F6:12:3D:BD:DE:44", char_uuid: "11002a00-0000-1000-8000-00805f9b34fb")

        expect(access_controller.error). to eq "Desciptors Empty. Characteristic Not Found."
      end
    end
  end

  describe "#discover_all_services_and_chars" do
  vcr_options = { cassette_name: 'access_controller/discover_all_services_and_chars/success', record: :new_episodes }
    context "when successful", vcr: vcr_options do
      it "sets the characteristics of a service and appends it to services" do
        access_controller = described_class.new
        router = Cassia::Router.new(mac: "CC:1B:E0:E0:F1:E8")
        connect_req = Cassia::Requests::ConnectLocal.new(access_controller, router: router, device_mac: "F6:12:3D:BD:DE:44", type: "random")
        connect_res = connect_req.perform

        access_controller.discover_all_services_and_chars(router: router, device_mac: "F6:12:3D:BD:DE:44")

        char1 = Cassia::Characteristic.new(uuid: "00002a00-0000-1000-8000-00805f9b34fb", handle: 3, properties: 10, descriptors: [{"handle"=>3, "uuid"=>"00002a00-0000-1000-8000-00805f9b34fb"}])
        char2 = Cassia::Characteristic.new(uuid: "00002a01-0000-1000-8000-00805f9b34fb", handle: 5, properties: 2, descriptors: [{"handle"=>5, "uuid"=>"00002a01-0000-1000-8000-00805f9b34fb"}])
        char3 = Cassia::Characteristic.new(uuid: "00002a04-0000-1000-8000-00805f9b34fb", handle: 7, properties: 2, descriptors: [{"handle"=>7, "uuid"=>"00002a04-0000-1000-8000-00805f9b34fb"}])
        char4 = Cassia::Characteristic.new(uuid: "00002aa6-0000-1000-8000-00805f9b34fb", handle: 9, properties: 2, descriptors: [{"handle"=>9, "uuid"=>"00002aa6-0000-1000-8000-00805f9b34fb"}])
        char5 = Cassia::Characteristic.new(uuid: "6e400003-b5a3-f393-e0a9-e50e24dcca9e", handle: 13, properties: 16, descriptors: [{"handle"=>13, "uuid"=>"6e400003-b5a3-f393-e0a9-e50e24dcca9e"}, {"handle"=>14, "uuid"=>"00002902-0000-1000-8000-00805f9b34fb"}])
        char6 = Cassia::Characteristic.new(uuid: "6e400002-b5a3-f393-e0a9-e50e24dcca9e", handle: 16, properties: 12, descriptors: [{"handle"=>16, "uuid"=>"6e400002-b5a3-f393-e0a9-e50e24dcca9e"}])
        service1 = Cassia::Service.new(uuid: "00001800-0000-1000-8000-00805f9b34fb", primary: true, characteristics: [char1, char2, char3, char4], handle: 1)

        expect(access_controller.connected_devices.first.characteristics).to eq [char1, char2, char3, char4, char5, char6]
        expect(access_controller.connected_devices.first.services).to include service1
      end
    end

  vcr_options = { cassette_name: 'access_controller/discover_all_services_and_chars/failure', record: :new_episodes }
    context "when unsuccessful" do
      it "sets the error", vcr: vcr_options do
        access_controller = described_class.new
        router = Cassia::Router.new(mac: "CC:1B:E0:E0:F1:E8")
        connect_req = Cassia::Requests::ConnectLocal.new(access_controller, router: router, device_mac: "F6:12:3D:BD:DE:44", type: "random")
        connect_res = connect_req.perform

        access_controller.discover_all_services_and_chars(router: router, device_mac: "F6:12:3D:BD:DE:40")

        expect(access_controller.error). to eq "device disconnect"
      end
    end
  end

  describe "#write_char_by_handle" do
  vcr_options = { cassette_name: 'access_controller/write_char_by_handle/success', record: :new_episodes }
    context "when successful", vcr: vcr_options do
      it "sets the notification_on attribute to true of a characteristic" do
        access_controller = described_class.new
        router = Cassia::Router.new(mac: "CC:1B:E0:E0:F1:E8")
        connect_req = Cassia::Requests::ConnectLocal.new(access_controller, router: router, device_mac: "F6:12:3D:BD:DE:44", type: "random")
        connect_res = connect_req.perform
        char_req = Cassia::Requests::DiscoverAllChar.new(access_controller, router: router, device_mac: "F6:12:3D:BD:DE:44")
        char_res = char_req.perform

        access_controller.write_char_by_handle(router: router, device_mac: "F6:12:3D:BD:DE:44", handle: 3, value: "0100")

        char = access_controller.connected_devices.first.characteristics.detect {|char| char.handle == 3}
        expect(char.notification_on).to eq true
      end

      it "sets the notification_on attribute to false of a characteristic" do
        access_controller = described_class.new
        router = Cassia::Router.new(mac: "CC:1B:E0:E0:F1:E8")
        connect_req = Cassia::Requests::ConnectLocal.new(access_controller, router: router, device_mac: "F6:12:3D:BD:DE:44", type: "random")
        connect_res = connect_req.perform
        char_req = Cassia::Requests::DiscoverAllChar.new(access_controller, router: router, device_mac: "F6:12:3D:BD:DE:44")
        char_res = char_req.perform

        access_controller.write_char_by_handle(router: router, device_mac: "F6:12:3D:BD:DE:44", handle: 3, value: "0000")

        char = access_controller.connected_devices.first.characteristics.detect {|char| char.handle == 3}
        expect(char.notification_on).to eq false
      end
    end

  vcr_options = { cassette_name: 'access_controller/write_char_by_handle/failure', record: :new_episodes }
    context "when unsuccessful" do
      it "sets the error", vcr: vcr_options do
        access_controller = described_class.new
        router = Cassia::Router.new(mac: "CC:1B:E0:E0:F1:E8")
        connect_req = Cassia::Requests::ConnectLocal.new(access_controller, router: router, device_mac: "F6:12:3D:BD:DE:44", type: "random")
        connect_res = connect_req.perform
        char_req = Cassia::Requests::DiscoverAllChar.new(access_controller, router: router, device_mac: "F6:12:3D:BD:DE:44")
        char_res = char_req.perform

        access_controller.write_char_by_handle(router: router, device_mac: "F6:12:3D:BD:DE:44", handle: 100, value: "0100")

        expect(access_controller.error). to eq "Characteristic With Given Handle Not Found"
      end
    end
  end
end
