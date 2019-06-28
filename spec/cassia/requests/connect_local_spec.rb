require 'spec_helper'

RSpec.describe Cassia::Requests::ConnectLocal do
  describe '#path' do
    it "returns the correct API endpoint" do
      router = Cassia::Router.new(mac: "CC:1B:E0:E0:F1:E8")
      request = described_class.new(Cassia::AccessController.new, router: router, device_mac: "F3:25:5F:22:35:39", type: "public")
      expect(request.path).to eq('/api/gap/nodes/F3:25:5F:22:35:39/connection?mac=CC:1B:E0:E0:F1:E8')
    end
  end

  describe '#body' do
    it "returns the correct params" do
      router = Cassia::Router.new(mac: "CC:1B:E0:E0:F1:E8")
      request = described_class.new(Cassia::AccessController.new, router: router,
      device_mac: "F3:25:5F:22:35:39", type: "public", timeout: '6000', auto: '1', discovergatt: '0' )
      
      expect(request.body).to eq(
        { 
          'type' => "public",
          'timeout' => '6000',
          'auto' => '1',
          'discovergatt' => '0'
        }.to_json
      )
    end
  end

  describe '#headers' do
    it "returns the correct authorization and content-type" do
      access_controller = Cassia::AccessController.new
      access_controller.access_token = "2ded2d8cf3073d368fec27243a71f858e9b9231d7388e63e6d2f70852c33e66f"
      router = Cassia::Router.new(mac: "CC:1B:E0:E0:F1:E8")
      request = described_class.new(access_controller, router: router, device_mac: "F3:25:5F:22:35:39", type: "public")

      expect(request.headers).to eq(
        {
          'Authorization' => "Bearer #{access_controller.access_token}",
          'Content-Type' => "application/json"
        }
      )
    end
  end

  describe '#perform' do
    vcr_options = { cassette_name: 'connect_local/success', record: :new_episodes }
      context "when passing in valid router and device_mac", vcr: vcr_options do
        it "returns true" do
          Cassia.configuration.client_id = ENV['CASSIA_CLIENT_ID']
          Cassia.configuration.secret = ENV['CASSIA_SECRET']
          access_controller = Cassia::AccessController.new
          scan_req = Cassia::Requests::OpenScan.new(access_controller, aps: ["CC:1B:E0:E0:F1:E8"])
          scan_res = scan_req.perform
          router = Cassia::Router.new(mac: "CC:1B:E0:E0:F1:E8")
          request = described_class.new(access_controller, router: router, device_mac: "F6:12:3D:BD:DE:44", type: "random")
         
          response = request.perform
          
          expect(response).to be_truthy
        end
      end

    vcr_options = { cassette_name: 'connect_local/failure', record: :new_episodes }
      context "when passing in invalid device_mac", vcr: vcr_options do
        it "returns false" do
          Cassia.configuration.client_id = ENV['CASSIA_CLIENT_ID']
          Cassia.configuration.secret = ENV['CASSIA_SECRET']
          access_controller = Cassia::AccessController.new
          router = Cassia::Router.new(mac: "CC:1B:E0:E0:F1:E8")
          request = described_class.new(access_controller, router: router, device_mac: "invalid_device_mac", type: "random")          
          response = request.perform

          expect(response).to be_falsey
        end
      end
  end
end
