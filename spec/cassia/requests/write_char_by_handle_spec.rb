require 'spec_helper'

RSpec.describe Cassia::Requests::WriteCharByHandle do
  describe '#path' do
    it "returns the correct API endpoint" do
      router = Cassia::Router.new(mac: "CC:1B:E0:E0:F1:E8")
      request = described_class.new(Cassia::AccessController.new, router: router, device_mac: "F3:25:5F:22:35:39", handle: 13, value: "0100")
      expect(request.path).to eq('/api/gatt/nodes/F3:25:5F:22:35:39/handle/13/value/0100?mac=CC:1B:E0:E0:F1:E8')
    end
  end

  describe '#headers' do
    it "returns the correct authorization and content-type" do
      access_controller = Cassia::AccessController.new
      access_controller.access_token = "2ded2d8cf3073d368fec27243a71f858e9b9231d7388e63e6d2f70852c33e66f"
      router = Cassia::Router.new(mac: "CC:1B:E0:E0:F1:E8")
      request = described_class.new(access_controller, router: router, device_mac: "F3:25:5F:22:35:39", handle: 13, value: "0100")

      expect(request.headers).to eq(
        {
          'Authorization' => "Bearer #{access_controller.access_token}",
          'Content-Type' => "application/json"
        }
      )
    end
  end

  describe '#perform' do
    vcr_options = { cassette_name: 'write_char_by_handle/success', record: :new_episodes }
      context "when passing in valid router, device_mac, handle and value", vcr: vcr_options do
        it "returns true" do
          Cassia.configuration.client_id = ENV['CASSIA_CLIENT_ID']
          Cassia.configuration.secret = ENV['CASSIA_SECRET']
          access_controller = Cassia::AccessController.new
          router = Cassia::Router.new(mac: "CC:1B:E0:E0:F1:E8")
          connect_req = Cassia::Requests::ConnectLocal.new(access_controller, router: router, device_mac: "F6:12:3D:BD:DE:44", type: "random")
          connect_res = connect_req.perform
          char_req = Cassia::Requests::DiscoverAllChar.new(access_controller, router: router, device_mac: "F6:12:3D:BD:DE:44")
          char_res = char_req.perform
          request = described_class.new(access_controller, router: router, device_mac: "F6:12:3D:BD:DE:44", handle: 3, value: "0100")

          response = request.perform

          expect(response).to be_truthy
        end
      end

    vcr_options = { cassette_name: 'write_char_by_handle/failure', record: :new_episodes }
      context "when passing in an invalid handle", vcr: vcr_options do
        it "returns false" do
          access_controller = Cassia::AccessController.new
          router = Cassia::Router.new(mac: "CC:1B:E0:E0:F1:E8")
          connect_req = Cassia::Requests::ConnectLocal.new(access_controller, router: router, device_mac: "F6:12:3D:BD:DE:44", type: "random")
          connect_res = connect_req.perform
          char_req = Cassia::Requests::DiscoverAllChar.new(access_controller, router: router, device_mac: "F6:12:3D:BD:DE:44")
          char_res = char_req.perform
          request = described_class.new(access_controller, router: router, device_mac: "F6:12:3D:BD:DE:44", handle: 100, value: "0100")

          response = request.perform

          expect(response).to be_falsey
        end
      end
  end
end
