require 'spec_helper'

RSpec.describe Cassia::Requests::GetToken do
  describe '#path' do
    it "returns the correct API endpoint" do
      request = described_class.new(Cassia::AccessController.new)

      expect(request.path).to eq('/api/oauth2/token')
    end
  end

  describe '#body' do
    it "returns the correct grant_type" do
      request = described_class.new(Cassia::AccessController.new)

      expect(request.body).to eq(
        {
          'grant_type' => "client_credentials"
        }.to_json
      )
    end
  end

  describe '#headers' do
    it "returns the correct authorization and content-type" do
      Cassia.configuration.client_id = "test"
      Cassia.configuration.secret = "12345"
      request = described_class.new(Cassia::AccessController.new)
      base64 = Base64.encode64("test:12345").strip

      expect(request.headers).to eq(
        {
          'Authorization' => "Basic #{base64}",
          'Content-Type' => "application/json"
        }
      )
    end
  end

  describe '#perform' do
    vcr_options = { cassette_name: 'token/success', record: :new_episodes }
    context "when passing valid credentials", vcr: vcr_options do
      it "returns true" do
        Cassia.configuration.client_id = ENV['CASSIA_CLIENT_ID']
        Cassia.configuration.secret = ENV['CASSIA_SECRET']
        request = described_class.new(Cassia::AccessController.new)

        response = request.perform

        expect(response).to be_truthy
      end
    end

    vcr_options = { cassette_name: 'token/failure', record: :new_episodes }
    context "when passing invalid credentials", vcr: vcr_options do
      it "returns false" do
        Cassia.configuration.client_id = "invalid"
        Cassia.configuration.secret = "invalid"
        request = described_class.new(Cassia::AccessController.new)
        
        response = request.perform

        expect(response).to be_falsey
      end
    end
  end
end
