require 'spec_helper'

RSpec.describe Cassia::Router do
  include FaradayHelpers
  
  describe "#connect_local" do
    vcr_options = { cassette_name: 'router/connect_local/success', record: :new_episodes }
      context "when successful", vcr: vcr_options do
        it "adds the device to connected_device" do
          Cassia.configuration.client_id = ENV['CASSIA_CLIENT_ID']
          Cassia.configuration.secret = ENV['CASSIA_SECRET']
          access_controller = Cassia::AccessController.new
          router = described_class.new(mac: "CC:1B:E0:E0:F1:E8")

          router.connect_local(access_controller, device_mac: "F6:12:3D:BD:DE:44", type: "random")

          expect(router.connected_devices).not_to be_nil
          expect(access_controller.connected_devices).not_to be_nil
        end
      end
    
    vcr_options = { cassette_name: 'router/connect_local/failure', record: :new_episodes }
      context "when unsuccessful", vcr: vcr_options do
        it "sets the error" do
          Cassia.configuration.client_id = ENV['CASSIA_CLIENT_ID']
          Cassia.configuration.secret = ENV['CASSIA_SECRET']
          access_controller = described_class.new
          access_controller = Cassia::AccessController.new
          router = described_class.new(mac: "CC:1B:E0:E0:F1:E8")

          router.connect_local(access_controller, device_mac: "invalid", type: "random")

          expect(access_controller.error). to eq "parameter invalid"
        end
      end
  end

  describe "#disconnect_local" do
    vcr_options = { cassette_name: 'router/disconnect_local/success', record: :new_episodes }
    context "when successful", vcr: vcr_options do
      it "removes the device from connected_device" do
        Cassia.configuration.client_id = ENV['CASSIA_CLIENT_ID']
        Cassia.configuration.secret = ENV['CASSIA_SECRET']
        access_controller = Cassia::AccessController.new
        router = described_class.new(mac: "CC:1B:E0:E0:F1:E8")
        connect_req = Cassia::Requests::ConnectLocal.new(access_controller, router: router, device_mac: "F6:12:3D:BD:DE:44", type: "random")
        connect_res = connect_req.perform
        
        router.disconnect_local(access_controller, device_mac: "F6:12:3D:BD:DE:44" )

        expect(router.connected_devices).to eq []
        expect(access_controller.connected_devices).to eq []
      end
    end

  vcr_options = { cassette_name: 'router/disconnect_local/failure', record: :new_episodes }
    context "when unsuccessful", vcr: vcr_options do
      it "sets the error" do
        Cassia.configuration.client_id = ENV['CASSIA_CLIENT_ID']
        Cassia.configuration.secret = ENV['CASSIA_SECRET']
        access_controller = described_class.new
        access_controller = Cassia::AccessController.new
        router = described_class.new(mac: "CC:1B:E0:E0:F1:E8")
        connect_req = Cassia::Requests::ConnectLocal.new(access_controller, router: router, device_mac: "F6:12:3D:BD:DE:44", type: "random")
        connect_res = connect_req.perform

        router.disconnect_local(access_controller, device_mac: "invalid_device_mac")

        expect(access_controller.error). to eq "parameter invalid"
      end
    end
  end

  describe "#get_connected_devices_router" do
    vcr_options = { cassette_name: 'router/get_connected_devices_router/success', record: :new_episodes }
    context "when successful", vcr: vcr_options do
      it "returns the connected_devices list" do
        Cassia.configuration.client_id = ENV['CASSIA_CLIENT_ID']
        Cassia.configuration.secret = ENV['CASSIA_SECRET']
        access_controller = Cassia::AccessController.new
        router = described_class.new(mac: "CC:1B:E0:E0:F1:E8")
        connect_req = Cassia::Requests::ConnectLocal.new(access_controller, router: router, device_mac: "F6:12:3D:BD:DE:44", type: "random")
        connect_res = connect_req.perform

        router.get_connected_devices(access_controller)

        expect(router.connected_devices[0].mac).to eq "F6:12:3D:BD:DE:44"
      end
    end

  vcr_options = { cassette_name: 'router/get_connected_devices_router/failure', record: :new_episodes }
    context "when unsuccessful", vcr: vcr_options do
      it "sets the error" do
        Cassia.configuration.client_id = ENV['CASSIA_CLIENT_ID']
        Cassia.configuration.secret = ENV['CASSIA_SECRET']
        access_controller = Cassia::AccessController.new
        router = described_class.new(mac: "invalid router mac")
        
        router.get_connected_devices(access_controller)

        expect(access_controller.error). to eq "router's mac is invalid"
      end
    end
  end

  describe "#discover_all_services" do
    vcr_options = { cassette_name: 'router/discover_all_services/success', record: :new_episodes }
    context "when successful", vcr: vcr_options do
      it "sets the services of the router" do
        Cassia.configuration.client_id = ENV['CASSIA_CLIENT_ID']
        Cassia.configuration.secret = ENV['CASSIA_SECRET']
        access_controller = Cassia::AccessController.new
        router = described_class.new(mac: "CC:1B:E0:E0:F1:E8")
        connect_req = Cassia::Requests::ConnectLocal.new(access_controller, router: router, device_mac: "F6:12:3D:BD:DE:44", type: "random")
        connect_res = connect_req.perform

        router.discover_all_services(access_controller, device_mac: "F6:12:3D:BD:DE:44")

        service1 = Cassia::Service.new(handle: 1, primary: true, uuid: "00001800-0000-1000-8000-00805f9b34fb")
        service2 = Cassia::Service.new(handle: 10, primary: true, uuid: "00001801-0000-1000-8000-00805f9b34fb")
        service3 = Cassia::Service.new(handle: 11, primary: true, uuid: "6e400001-b5a3-f393-e0a9-e50e24dcca9e")
        
        expect(router.connected_devices[0].services).to eq [service1, service2, service3]
      end
    end

  vcr_options = { cassette_name: 'router/discover_all_services/failure', record: :new_episodes }
    context "when unsuccessful", vcr: vcr_options do
      it "sets the error" do
        Cassia.configuration.client_id = ENV['CASSIA_CLIENT_ID']
        Cassia.configuration.secret = ENV['CASSIA_SECRET']
        access_controller = Cassia::AccessController.new
        router = described_class.new(mac: "CC:1B:E0:E0:F1:E8")
        connect_req = Cassia::Requests::ConnectLocal.new(access_controller, router: router, device_mac: "F6:12:3D:BD:DE:44", type: "random")
        connect_res = connect_req.perform
        
        router.discover_all_services(access_controller, device_mac: "F6:12:3D:BD:DE:40")

        expect(access_controller.error). to eq "device disconnect"
      end
    end
  end

  describe "#discover_all_char" do
    vcr_options = { cassette_name: 'router/discover_all_char/success', record: :new_episodes }
    context "when successful", vcr: vcr_options do
      it "sets the characteristics of the router" do
        Cassia.configuration.client_id = ENV['CASSIA_CLIENT_ID']
        Cassia.configuration.secret = ENV['CASSIA_SECRET']
        access_controller = Cassia::AccessController.new
        router = described_class.new(mac: "CC:1B:E0:E0:F1:E8")
        connect_req = Cassia::Requests::ConnectLocal.new(access_controller, router: router, device_mac: "F6:12:3D:BD:DE:44", type: "random")
        connect_res = connect_req.perform

        router.discover_all_char(access_controller, device_mac: "F6:12:3D:BD:DE:44")

        char1 = Cassia::Characteristic.new(uuid: "00002a00-0000-1000-8000-00805f9b34fb", handle: 3, properties: 10)
        char2 = Cassia::Characteristic.new(uuid: "00002a01-0000-1000-8000-00805f9b34fb", handle: 5, properties: 2)
        char3 = Cassia::Characteristic.new(uuid: "00002a04-0000-1000-8000-00805f9b34fb", handle: 7, properties: 2)
        char4 = Cassia::Characteristic.new(uuid: "00002aa6-0000-1000-8000-00805f9b34fb", handle: 9, properties: 2)
        char5 = Cassia::Characteristic.new(uuid: "6e400003-b5a3-f393-e0a9-e50e24dcca9e", handle: 13, properties: 16)
        char6 = Cassia::Characteristic.new(uuid: "6e400002-b5a3-f393-e0a9-e50e24dcca9e", handle: 16, properties: 12)
        
        expect(router.connected_devices[0].characteristics).to eq [char1, char2, char3, char4, char5, char6]
      end
    end

  vcr_options = { cassette_name: 'router/discover_all_char/failure', record: :new_episodes }
    context "when unsuccessful", vcr: vcr_options do
      it "sets the error" do
        Cassia.configuration.client_id = ENV['CASSIA_CLIENT_ID']
        Cassia.configuration.secret = ENV['CASSIA_SECRET']
        access_controller = Cassia::AccessController.new
        router = described_class.new(mac: "CC:1B:E0:E0:F1:E8")
        connect_req = Cassia::Requests::ConnectLocal.new(access_controller, router: router, device_mac: "F6:12:3D:BD:DE:44", type: "random")
        connect_res = connect_req.perform
        
        router.discover_all_char(access_controller, device_mac: "F6:12:3D:BD:DE:40")

        expect(access_controller.error). to eq "device disconnect"
      end
    end
  end

  describe "#discover_char_of_service" do
    vcr_options = { cassette_name: 'router/discover_char_of_service/success', record: :new_episodes }
    context "when successful", vcr: vcr_options do
      it "sets the characteristics of a service" do
        Cassia.configuration.client_id = ENV['CASSIA_CLIENT_ID']
        Cassia.configuration.secret = ENV['CASSIA_SECRET']
        access_controller = Cassia::AccessController.new
        router = described_class.new(mac: "CC:1B:E0:E0:F1:E8")
        connect_req = Cassia::Requests::ConnectLocal.new(access_controller, router: router, device_mac: "F6:12:3D:BD:DE:44", type: "random")
        connect_res = connect_req.perform
        service_req = Cassia::Requests::DiscoverAllServices.new(access_controller, router: router, device_mac: "F6:12:3D:BD:DE:44")
        service_res = service_req.perform

        router.discover_char_of_service(access_controller, device_mac: "F6:12:3D:BD:DE:44", service_uuid: "00001800-0000-1000-8000-00805f9b34fb")

        char1 = Cassia::Characteristic.new(uuid: "00002a00-0000-1000-8000-00805f9b34fb", handle: 3, properties: 10)
        char2 = Cassia::Characteristic.new(uuid: "00002a01-0000-1000-8000-00805f9b34fb", handle: 5, properties: 2)
        char3 = Cassia::Characteristic.new(uuid: "00002a04-0000-1000-8000-00805f9b34fb", handle: 7, properties: 2)
        char4 = Cassia::Characteristic.new(uuid: "00002aa6-0000-1000-8000-00805f9b34fb", handle: 9, properties: 2)
        
        expect(router.connected_devices[0].characteristics).to eq [char1, char2, char3, char4]
      end
    end

  vcr_options = { cassette_name: 'router/discover_char_of_service/failure', record: :new_episodes }
    context "when unsuccessful", vcr: vcr_options do
      it "sets the error" do
        Cassia.configuration.client_id = ENV['CASSIA_CLIENT_ID']
        Cassia.configuration.secret = ENV['CASSIA_SECRET']
        access_controller = Cassia::AccessController.new
        router = described_class.new(mac: "CC:1B:E0:E0:F1:E8")
        connect_req = Cassia::Requests::ConnectLocal.new(access_controller, router: router, device_mac: "F6:12:3D:BD:DE:44", type: "random")
        connect_res = connect_req.perform
        service_req = Cassia::Requests::DiscoverAllServices.new(access_controller, router: router, device_mac: "F6:12:3D:BD:DE:44")
        service_res = service_req.perform

        router.discover_char_of_service(access_controller, device_mac: "F6:12:3D:BD:DE:44", service_uuid: "11001800-0000-1000-8000-00805f9b34fb")

        expect(access_controller.error). to eq "Service Not Found"
      end
    end
  end

  describe "#discover_descriptor_of_char" do
    vcr_options = { cassette_name: 'router/discover_descriptor_of_char/success', record: :new_episodes }
    context "when successful", vcr: vcr_options do
      it "sets the descriptors of a characteristic" do
        Cassia.configuration.client_id = ENV['CASSIA_CLIENT_ID']
        Cassia.configuration.secret = ENV['CASSIA_SECRET']
        access_controller = Cassia::AccessController.new
        router = described_class.new(mac: "CC:1B:E0:E0:F1:E8")
        connect_req = Cassia::Requests::ConnectLocal.new(access_controller, router: router, device_mac: "F6:12:3D:BD:DE:44", type: "random")
        connect_res = connect_req.perform
        service_req = Cassia::Requests::DiscoverAllServices.new(access_controller, router: router, device_mac: "F6:12:3D:BD:DE:44")
        service_res = service_req.perform
        char_req = Cassia::Requests::DiscoverAllChar.new(access_controller, router: router, device_mac: "F6:12:3D:BD:DE:44")
        char_res = char_req.perform

        router.discover_descriptor_of_char(access_controller, device_mac: "F6:12:3D:BD:DE:44", char_uuid: "00002a00-0000-1000-8000-00805f9b34fb")

        char = router.connected_devices[0].characteristics.detect {|char| char.uuid == "00002a00-0000-1000-8000-00805f9b34fb"}
        expect(char.descriptors).to eq [{"handle"=>3, "uuid"=>"00002a00-0000-1000-8000-00805f9b34fb"}]
      end
    end

  vcr_options = { cassette_name: 'router/discover_descriptor_of_char/failure', record: :new_episodes }
    context "when unsuccessful", vcr: vcr_options do
      it "sets the error" do
        Cassia.configuration.client_id = ENV['CASSIA_CLIENT_ID']
        Cassia.configuration.secret = ENV['CASSIA_SECRET']
        access_controller = Cassia::AccessController.new
        router = described_class.new(mac: "CC:1B:E0:E0:F1:E8")
        connect_req = Cassia::Requests::ConnectLocal.new(access_controller, router: router, device_mac: "F6:12:3D:BD:DE:44", type: "random")
        connect_res = connect_req.perform
        char_req = Cassia::Requests::DiscoverAllChar.new(access_controller, router: router, device_mac: "F6:12:3D:BD:DE:44")
        char_res = char_req.perform

        router.discover_descriptor_of_char(access_controller, device_mac: "F6:12:3D:BD:DE:44", char_uuid: "11002a00-0000-1000-8000-00805f9b34fb")

        expect(access_controller.error). to eq "descriptors empty"
      end
    end
  end

  describe "#discover_all" do
    vcr_options = { cassette_name: 'router/discover_all/success', record: :new_episodes }
    context "when successful", vcr: vcr_options do
      it "sets the characteristics of a service and appends it to services" do
        Cassia.configuration.client_id = ENV['CASSIA_CLIENT_ID']
        Cassia.configuration.secret = ENV['CASSIA_SECRET']
        access_controller = Cassia::AccessController.new
        router = described_class.new(mac: "CC:1B:E0:E0:F1:E8")
        connect_req = Cassia::Requests::ConnectLocal.new(access_controller, router: router, device_mac: "F6:12:3D:BD:DE:44", type: "random")
        connect_res = connect_req.perform
        
        router.discover_all(access_controller, device_mac: "F6:12:3D:BD:DE:44")

        char1 = Cassia::Characteristic.new(uuid: "00002a00-0000-1000-8000-00805f9b34fb", handle: 3, properties: 10, descriptors: [{"handle"=>3, "uuid"=>"00002a00-0000-1000-8000-00805f9b34fb"}])
        char2 = Cassia::Characteristic.new(uuid: "00002a01-0000-1000-8000-00805f9b34fb", handle: 5, properties: 2, descriptors: [{"handle"=>5, "uuid"=>"00002a01-0000-1000-8000-00805f9b34fb"}])
        char3 = Cassia::Characteristic.new(uuid: "00002a04-0000-1000-8000-00805f9b34fb", handle: 7, properties: 2, descriptors: [{"handle"=>7, "uuid"=>"00002a04-0000-1000-8000-00805f9b34fb"}])
        char4 = Cassia::Characteristic.new(uuid: "00002aa6-0000-1000-8000-00805f9b34fb", handle: 9, properties: 2, descriptors: [{"handle"=>9, "uuid"=>"00002aa6-0000-1000-8000-00805f9b34fb"}])
        char5 = Cassia::Characteristic.new(uuid: "6e400003-b5a3-f393-e0a9-e50e24dcca9e", handle: 13, properties: 16, descriptors: [{"handle"=>13, "uuid"=>"6e400003-b5a3-f393-e0a9-e50e24dcca9e"}, {"handle"=>14, "uuid"=>"00002902-0000-1000-8000-00805f9b34fb"}])
        char6 = Cassia::Characteristic.new(uuid: "6e400002-b5a3-f393-e0a9-e50e24dcca9e", handle: 16, properties: 12, descriptors: [{"handle"=>16, "uuid"=>"6e400002-b5a3-f393-e0a9-e50e24dcca9e"}])
        service1 = Cassia::Service.new(uuid: "00001800-0000-1000-8000-00805f9b34fb", primary: true, characteristics: [char1, char2, char3, char4], handle: 1)
        
        expect(router.connected_devices[0].characteristics).to eq [char1, char2, char3, char4, char5, char6]
        expect(router.connected_devices[0].services).to include service1
      end
    end

  vcr_options = { cassette_name: 'router/discover_all/failure', record: :new_episodes }
    context "when unsuccessful", vcr: vcr_options do
      it "sets the error" do
        Cassia.configuration.client_id = ENV['CASSIA_CLIENT_ID']
        Cassia.configuration.secret = ENV['CASSIA_SECRET']
        access_controller = Cassia::AccessController.new
        router = described_class.new(mac: "CC:1B:E0:E0:F1:E8")
        connect_req = Cassia::Requests::ConnectLocal.new(access_controller, router: router, device_mac: "F6:12:3D:BD:DE:44", type: "random")
        connect_res = connect_req.perform
        
        router.discover_all(access_controller, device_mac: "F6:12:3D:BD:DE:40")

        expect(access_controller.error). to eq "device disconnect"
      end
    end
  end
end
