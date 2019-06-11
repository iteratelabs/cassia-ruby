require 'spec_helper'

RSpec.describe Cassia::Requests::GetToken do
  describe '#path' do
    it "returns the correct API endpoint" do
      request = described_class.new

      expect(request.path).to eq('/oauth2/token')
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

      base64 = Base64.encode64("test:12345")
      expect(request.headers).to eq(
        {
          'Authorization' => "Basic #{base64}",
          'Content-Type' => "application/json"
        }
      )
    end
  end

  describe '#perform' do
    it "returns the correct request" do
      Cassia.configuration.client_id = ENV['CASSIA_CLIENT_ID']
      ci = Cassia.configuration.client_id
      puts ci
      Cassia.configuration.secret = ENV['CASSIA_SECRET']
      s = Cassia.configuration.secret
      puts s

      request = described_class.new
      response = request.perform
      puts response
      puts response.body
      puts response.status
    end
  end
end