require 'spec_helper'

RSpec.describe Cassia::Requests::GetToken do
  describe '#path' do
    it "returns the correct API endpoint" do
      request = described_class.new

      expect(request.path).to eq('/api/oauth2/token')
    end
  end

  describe '#body' do
    it "returns the correct grant_type" do
      request = described_class.new

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

      request = described_class.new

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
    context "when passing valid credentials" do
      it "returns a 200 response" do
        Cassia.configuration.client_id = ENV['CASSIA_CLIENT_ID']
        Cassia.configuration.secret = ENV['CASSIA_SECRET']

        request = described_class.new
        response = request.perform

        expect(response.status).to eq 200
      end

      it "returns a valid token" do
        Cassia.configuration.client_id = ENV['CASSIA_CLIENT_ID']
        Cassia.configuration.secret = ENV['CASSIA_SECRET']

        request = described_class.new
        response = request.perform

        expect(response.body).to have_key("access_token")
      end
    end

    context "when passing invalid credentials" do
      it "returns a 401" do
        Cassia.configuration.client_id = "invalid"
        Cassia.configuration.secret = "invalid"

        request = described_class.new
        response = request.perform

        expect(response.status).to eq 401
      end

      it "returns an invalid response" do
        Cassia.configuration.client_id = "invalid"
        Cassia.configuration.secret = "invalid"

        request = described_class.new
        response = request.perform

        expect(response.body['error']).to eq("invalid_client")
        expect(response.body['error_description']).to eq("Client not found")
      end
    end
  end
end
