require 'spec_helper'

RSpec.describe Cassia::Requests::DiscoverCharOfService do
  describe '#path' do
    it "returns the correct API endpoint" do
      router = Cassia::Router.new(mac: "CC:1B:E0:E0:F1:E8")
      request = described_class.new(Cassia::AccessController.new, router: router, device_mac: "F6:12:3D:BD:DE:44", service_uuid: "00001800-0000-1000-8000-00805f9b34fb")
      expect(request.path).to eq('/api/gatt/nodes/F6:12:3D:BD:DE:44/services/00001800-0000-1000-8000-00805f9b34fb/characteristics?mac=CC:1B:E0:E0:F1:E8')
    end
  end

  describe '#headers' do
    it "returns the correct authorization and content-type" do
      access_controller = Cassia::AccessController.new
      access_controller.access_token = "2ded2d8cf3073d368fec27243a71f858e9b9231d7388e63e6d2f70852c33e66f"
      router = Cassia::Router.new(mac: "CC:1B:E0:E0:F1:E8")
      request = described_class.new(access_controller, router: router, device_mac: "F6:12:3D:BD:DE:44", service_uuid: "00001800-0000-1000-8000-00805f9b34fb")

      expect(request.headers).to eq(
        {
          'Authorization' => "Bearer #{access_controller.access_token}",
          'Content-Type' => "application/json"
        }
      )
    end
  end

  describe '#perform' do
    vcr_options = { cassette_name: 'discover_char_of_service/success', record: :new_episodes }
      context "when passing in valid router, device_mac, and service_uuid", vcr: vcr_options do
        it "returns true" do
          access_controller = Cassia::AccessController.new
          router = Cassia::Router.new(mac: "CC:1B:E0:E0:F1:E8")
          connect_req = Cassia::Requests::ConnectLocal.new(access_controller, router: router, device_mac: "F6:12:3D:BD:DE:44", type: "random")
          connect_res = connect_req.perform
          service_req = Cassia::Requests::DiscoverAllServices.new(access_controller, router: router, device_mac: "F6:12:3D:BD:DE:44")
          service_res = service_req.perform
          request = described_class.new(access_controller, router: router, device_mac: "F6:12:3D:BD:DE:44", service_uuid: "00001800-0000-1000-8000-00805f9b34fb")

          response = request.perform

          expect(response).to be_truthy
        end
      end

    vcr_options = { cassette_name: 'discover_char_of_service/failure', record: :new_episodes }
      context "when passing in an invalid service_uuid", vcr: vcr_options do
        it "returns false" do
          access_controller = Cassia::AccessController.new
          router = Cassia::Router.new(mac: "CC:1B:E0:E0:F1:E8")
          connect_req = Cassia::Requests::ConnectLocal.new(access_controller, router: router, device_mac: "F6:12:3D:BD:DE:44", type: "random")
          connect_res = connect_req.perform
          service_req = Cassia::Requests::DiscoverAllServices.new(access_controller, router: router, device_mac: "F6:12:3D:BD:DE:44")
          service_res = service_req.perform
          request = described_class.new(access_controller, router: router, device_mac: "F6:12:3D:BD:DE:44", service_uuid: "11001800-0000-1000-8000-00805f9b34fb")

          response = request.perform

          expect(response).to be_falsey
        end
      end
  end
end
