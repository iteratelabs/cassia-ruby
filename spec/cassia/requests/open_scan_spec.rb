require 'spec_helper'

RSpec.describe Cassia::Requests::OpenScan do
  describe '#path' do
    it "returns the correct API endpoint" do
      request = described_class.new

      expect(request.path).to eq('/api/aps/scan/open')
    end
  end

  describe '#body' do
    it "returns the correct request" do
      request = described_class.new(aps: ["CC:1B:E0:E0:ED:AC", "CC:1B:E0:E0:F1:E8"], chip: 0, active: 1)
      expect(request.body).to eq(
        {
          'aps' => ["CC:1B:E0:E0:ED:AC", "CC:1B:E0:E0:F1:E8"],
          'chip' => 0,
          'active' => 1
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
    vcr_options = { cassette_name: 'open_scan/success', record: :new_episodes }
      context "when passing in valid aps", vcr: vcr_options do
        it "returns a 202" do
          Cassia.configuration.client_id = ENV['CASSIA_CLIENT_ID']
          Cassia.configuration.secret = ENV['CASSIA_SECRET']
          request = described_class.new(aps: ["CC:1B:E0:E0:ED:AC", "CC:1B:E0:E0:F1:E8"])
          response = request.perform

          expect(response.status).to eq 202
        end
      end

    vcr_options = { cassette_name: 'open_scan/failure', record: :new_episodes }
      context "when passing invalid aps", vcr: vcr_options do
        it "returns a 400" do
          Cassia.configuration.client_id = ENV['CASSIA_CLIENT_ID']
          Cassia.configuration.secret = ENV['CASSIA_SECRET']
          request = described_class.new
          response = request.perform

          expect(response.status).to eq 400
        end
      end
  end
end
