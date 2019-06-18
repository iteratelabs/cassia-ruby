require 'spec_helper'

RSpec.describe Cassia::Requests::ConnectDevice do
  describe '#path' do
    it "returns the correct API endpoint" do
      request = described_class.new( aps: ["CC:1B:E0:E7:FE:F8","CC:1B:E0:E7:FE:F9","CC:1B:E0:E7:FE:FA"],
        mac: "F7:18:BC:18:F0:3A" )

      expect(request.path).to eq('/api/aps/connections/connect')
    end
  end

  describe '#body' do
    it "returns the correct aps and devices" do
      request = described_class.new(aps: ["CC:1B:E0:E0:ED:AC", "CC:1B:E0:E0:F1:E8"], mac: "CC:1B:E0:E0:ED:AC" )
      expect(request.body).to eq(
        {
          'aps' => ["CC:1B:E0:E0:ED:AC", "CC:1B:E0:E0:F1:E8"],
          'devices' => ["CC:1B:E0:E0:ED:AC"]
        }.to_json
      )
    end
  end

  describe '#headers' do
    it "returns the correct authorization and content-type" do
      Cassia.configuration.client_id = "test"
      Cassia.configuration.secret = "12345"
      access_token = "2ded2d8cf3073d368fec27243a71f858e9b9231d7388e63e6d2f70852c33e66f"
      
      request = described_class.new(access_token: access_token)

      expect(request.headers).to eq(
        {
          'Authorization' => "Bearer #{access_token}",
          'Content-Type' => "application/json"
        }
      )
    end
  end

  describe '#perform' do
    vcr_options = { cassette_name: 'connect_device/success', record: :new_episodes }
      context "when passing in valid aps and MAC", vcr: vcr_options do
        it "returns the correct response" do
          Cassia.configuration.client_id = ENV['CASSIA_CLIENT_ID']
          Cassia.configuration.secret = ENV['CASSIA_SECRET']
          request = described_class.new(aps: ["CC:1B:E0:E0:ED:AC", "CC:1B:E0:E0:F1:E8"],
            mac: "F3:25:5F:22:35:39" )
          response = request.perform
          puts response.body

          expect(response.status).to eq 200
        end
      end

    vcr_options = { cassette_name: 'connect_device/failure', record: :new_episodes }
      context "when passing invalid aps or MAC", vcr: vcr_options do
        it "returns a 400 and error message invalid devices" do
          Cassia.configuration.client_id = ENV['CASSIA_CLIENT_ID']
          Cassia.configuration.secret = ENV['CASSIA_SECRET']
          request = described_class.new(mac: ["CC:1B:E0:E0:ED:AC", "CC:1B:E0:E0:F1:E8"])
          response = request.perform
          puts response.body

          expect(response.status).to eq 400
          expect(response.body).to include("status" => "bad request", "error" => "invalid devices")
        end
      end
  end
end
