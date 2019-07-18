require 'spec_helper'

RSpec.describe Cassia::Requests::GetConnectedDevicesRouter do
  describe '#path' do
    it "returns the correct API endpoint" do
      router = Cassia::Router.new(mac: "CC:1B:E0:E0:F1:E8")
      request = described_class.new(Cassia::AccessController.new, router: router)

      expect(request.path).to eq('/api/gap/nodes?connection_state=connected&mac=CC:1B:E0:E0:F1:E8')
    end
  end

  describe '#headers' do
    it "returns the correct authorization and content-type" do
      access_controller = Cassia::AccessController.new
      access_controller.access_token = "2ded2d8cf3073d368fec27243a71f858e9b9231d7388e63e6d2f70852c33e66f"
      router = Cassia::Router.new(mac: "CC:1B:E0:E0:F1:E8")
      request = described_class.new(access_controller, router: router)

      expect(request.headers).to eq(
        {
          'Authorization' => "Bearer #{access_controller.access_token}",
          'Content-Type' => "application/json"
        }
      )
    end
  end

  describe '#perform' do
    vcr_options = { cassette_name: 'get_connected_devices_router/success', record: :new_episodes }
    context "when passing a valid router", vcr: vcr_options do
      it "returns true" do
        access_controller = Cassia::AccessController.new
        router = Cassia::Router.new(mac: "CC:1B:E0:E0:F1:E8")
        request = described_class.new(access_controller, router: router)

        response = request.perform

        expect(response).to be_truthy
      end
    end

    vcr_options = { cassette_name: 'get_connected_devices_router/failure', record: :new_episodes }
    context "when passing an invalid router", vcr: vcr_options do
      it "returns false" do
        access_controller = Cassia::AccessController.new
        router = Cassia::Router.new(mac: "invalid router mac")
        request = described_class.new(access_controller, router: router)

        response = request.perform

        expect(response).to be_falsey
      end
    end
  end
end
