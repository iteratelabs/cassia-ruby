require 'spec_helper'

RSpec.describe Cassia::Requests::DisconnectDevice do
  describe '#path' do
    it "returns the correct API endpoint" do
      request = described_class.new(Cassia::AccessController.new, device_mac: "F6:12:3D:BD:DE:44" )

      expect(request.path).to eq('/api/aps/connections/disconnect')
    end
  end

  describe '#body' do
    it "returns the correct device" do
      request = described_class.new(Cassia::AccessController.new, device_mac: "F6:12:3D:BD:DE:44" )
      
      expect(request.body).to eq(
        {
          'devices' => ["F6:12:3D:BD:DE:44"]
        }.to_json
      )
    end
  end

  describe '#headers' do
    it "returns the correct authorization and content-type" do
      access_controller = Cassia::AccessController.new
      access_controller.access_token = "2ded2d8cf3073d368fec27243a71f858e9b9231d7388e63e6d2f70852c33e66f"
      request = described_class.new(access_controller, device_mac: "F6:12:3D:BD:DE:44")

      expect(request.headers).to eq(
        {
          'Authorization' => "Bearer #{access_controller.access_token}",
          'Content-Type' => "application/json"
        }
      )
    end
  end

  describe '#perform' do
    vcr_options = { cassette_name: 'disconnect_device/success', record: :new_episodes }
      context "when passing in a valid device_mac", vcr: vcr_options do
        it "returns the correct response" do
          Cassia.configuration.client_id = ENV['CASSIA_CLIENT_ID']
          Cassia.configuration.secret = ENV['CASSIA_SECRET']
          access_controller = Cassia::AccessController.new
          autoselect_req = Cassia::Requests::SwitchAutoselect.new(access_controller, flag: 1)
          autoselect_res = autoselect_req.perform
          scan_req = Cassia::Requests::OpenScan.new(access_controller, aps: ["CC:1B:E0:E0:F1:E8"])
          scan_res = scan_req.perform
          connect_req = Cassia::Requests::ConnectDevice.new(access_controller, device_mac: "F6:12:3D:BD:DE:44")
          connect_res = connect_req.perform
          request = described_class.new(access_controller, device_mac: "F6:12:3D:BD:DE:44" )

          response = request.perform
          
          expect(response).to be_truthy
        end
      end

    vcr_options = { cassette_name: 'disconnect_device/failure', record: :new_episodes }
      context "when passing an invalid device_mac", vcr: vcr_options do
        it "returns a 400 and error message invalid devices" do
          access_controller = Cassia::AccessController.new
          autoselect_req = Cassia::Requests::SwitchAutoselect.new(access_controller, flag: 1)
          autoselect_res = autoselect_req.perform
          scan_req = Cassia::Requests::OpenScan.new(access_controller, aps: ["CC:1B:E0:E0:F1:E8"])
          scan_res = scan_req.perform
          connect_req = Cassia::Requests::ConnectDevice.new(access_controller, device_mac: "F6:12:3D:BD:DE:44")
          connect_res = connect_req.perform
          request = described_class.new(Cassia::AccessController.new, device_mac: ["CC:1B:E0:E0:ED:AC", "CC:1B:E0:E0:F1:E8"])
          
          response = request.perform

          expect(response).to be_falsey
        end
      end
  end
end
