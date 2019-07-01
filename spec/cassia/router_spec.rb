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
end
