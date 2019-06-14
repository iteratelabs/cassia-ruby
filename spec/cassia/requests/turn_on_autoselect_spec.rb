require 'spec_helper'

RSpec.describe Cassia::Requests::TurnOnAutoselect do
  describe '#path' do
    it "returns the correct API endpoint" do
      request = described_class.new

      expect(request.path).to eq('/api/aps/ap-select-switch')
    end
  end

  describe '#body' do
    it "returns the correct flag" do
      request = described_class.new

      expect(request.body).to eq(
        {
          'flag' => 1
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
    vcr_options = { cassette_name: 'turn_on_autoselect/success', record: :new_episodes }
    context "when passing a valid access token", vcr: vcr_options do
      it "returns a 200 response" do
        Cassia.configuration.client_id = ENV['CASSIA_CLIENT_ID']
        Cassia.configuration.secret = ENV['CASSIA_SECRET']

        request = described_class.new
        response = request.perform

        expect(response.status).to eq 200
      end

      it "returns a successful status and a flag 1" do

        request = described_class.new
        response = request.perform

        expect(response.body).to have_key("status")
        expect(response.body["status"]).to eq "success"
        expect(response.body).to have_key("flag")
        expect(response.body["flag"]).to eq 1
      end
    end

    vcr_options = { cassette_name: 'turn_on_autoselect/failure', record: :new_episodes }
    context "when passing an invalid access token", vcr: vcr_options do
      it "returns a 403" do
        request = described_class.new(access_token: "invalid_access_token")
        response = request.perform

        expect(response.status).to eq 403
      end
    end
  end
end
