require 'spec_helper'

RSpec.describe Cassia::AccessController do
  include FaradayHelpers
  
  describe "#get_token" do
    vcr_options = { cassette_name: 'access_controller/get_token/success', record: :new_episodes }
      context "when successful", vcr: vcr_options do
        it "sets the access_token" do
          access_controller = described_class.new

          access_controller.get_token

          expect(access_controller.access_token).not_to be_nil
        end
      end
    
    vcr_options = { cassette_name: 'access_controller/get_token/failure', record: :new_episodes }
      context "when unsuccessful", vcr: vcr_options do
        it "sets the error and error_description values" do
          Cassia.configuration.client_id = "invalid"
          Cassia.configuration.secret = "invalid"
          access_controller = described_class.new

          access_controller.get_token

          expect(access_controller.error). to eq "invalid_client"
          expect(access_controller.error_description). to eq "Client not found"
        end
      end
  end

  describe "#get_all_routers_status" do
    vcr_options = { cassette_name: 'access_controller/routersstatus/success', record: :new_episodes }
      context "when successful", vcr: vcr_options do
        it "appends routers to the array" do
          Cassia.configuration.client_id = ENV['CASSIA_CLIENT_ID']
          Cassia.configuration.secret = ENV['CASSIA_SECRET']
          access_controller = described_class.new

          access_controller.get_all_routers_status

          expect(access_controller.routers).not_to be_empty
        end
      end

    vcr_options = { cassette_name: 'access_controller/routersstatus/failure', record: :new_episodes }
    context "when unsuccessful", vcr: vcr_options do
      it "sets the error and error_description values" do
        Cassia.configuration.client_id = "invalid"
        Cassia.configuration.secret = "invalid"
        access_controller = described_class.new

        access_controller.get_all_routers_status

        expect(access_controller.error). to eq "access_denied"
        expect(access_controller.error_description). to eq "Wrong authorization header"
      end
    end
  end

  describe "#switch_autoselect" do
    vcr_options = { cassette_name: 'access_controller/switch_autoselect/success_1', record: :new_episodes }
        context "when successfully switching to 1", vcr: vcr_options do
          it "sets the switch to 1" do
            Cassia.configuration.client_id = ENV['CASSIA_CLIENT_ID']
            Cassia.configuration.secret = ENV['CASSIA_SECRET']
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
        Cassia.configuration.client_id = "invalid"
        Cassia.configuration.secret = "invalid"
        access_controller = described_class.new

        access_controller.switch_autoselect(flag: 0)

        expect(access_controller.error). to eq "access_denied"
        expect(access_controller.error_description). to eq "Wrong authorization header"
      end
    end
  end

  describe "#open_scan" do
    vcr_options = { cassette_name: 'access_controller/open_scan/failure', record: :new_episodes }
      context "when unsuccessful", vcr: vcr_options do
        it "sets the error" do
          Cassia.configuration.client_id = ENV['CASSIA_CLIENT_ID']
          Cassia.configuration.secret = ENV['CASSIA_SECRET']
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
          Cassia.configuration.client_id = ENV['CASSIA_CLIENT_ID']
          Cassia.configuration.secret = ENV['CASSIA_SECRET']
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
          Cassia.configuration.client_id = ENV['CASSIA_CLIENT_ID']
          Cassia.configuration.secret = ENV['CASSIA_SECRET']
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
          Cassia.configuration.client_id = ENV['CASSIA_CLIENT_ID']
          Cassia.configuration.secret = ENV['CASSIA_SECRET']
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
          Cassia.configuration.client_id = ENV['CASSIA_CLIENT_ID']
          Cassia.configuration.secret = ENV['CASSIA_SECRET']
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
          Cassia.configuration.client_id = ENV['CASSIA_CLIENT_ID']
          Cassia.configuration.secret = ENV['CASSIA_SECRET']
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
          Cassia.configuration.client_id = ENV['CASSIA_CLIENT_ID']
          Cassia.configuration.secret = ENV['CASSIA_SECRET']
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
          Cassia.configuration.client_id = "invalid client id"
          Cassia.configuration.secret = "invalid secret"
          access_controller = described_class.new

          access_controller.open_ap_state
          
          expect(access_controller.error). to eq "access_denied"
          expect(access_controller.error_description).to eq "Wrong authorization header"
        end
      end
  end
end
