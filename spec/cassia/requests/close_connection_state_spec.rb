require 'spec_helper'

RSpec.describe Cassia::Requests::CloseConnectionState do
  describe '#path' do
    it "returns the correct API endpoint" do
      request = described_class.new(Cassia::AccessController.new, aps: ["CC:1B:E0:E0:ED:AC", "CC:1B:E0:E0:F1:E8"])

      expect(request.path).to eq('/api/aps/connection-state/close')
    end
  end

  describe '#body' do
    it "returns the correct request" do
      request = described_class.new(Cassia::AccessController.new, aps: ["CC:1B:E0:E0:ED:AC", "CC:1B:E0:E0:F1:E8"])

      expect(request.body).to eq(
        {
          'aps' => ["CC:1B:E0:E0:ED:AC", "CC:1B:E0:E0:F1:E8"]
        }.to_json
      )
    end
  end

  describe '#headers' do
    it "returns the correct authorization and content-type" do
      access_controller = Cassia::AccessController.new
      access_controller.access_token = "2ded2d8cf3073d368fec27243a71f858e9b9231d7388e63e6d2f70852c33e66f"
      request = described_class.new(access_controller, aps: ["CC:1B:E0:E0:ED:AC", "CC:1B:E0:E0:F1:E8"])

      expect(request.headers).to eq(
        {
          'Authorization' => "Bearer #{access_controller.access_token}",
          'Content-Type' => "application/json"
        }
      )
    end
  end

  describe '#perform' do
    vcr_options = { cassette_name: 'close_connection_state/success', record: :new_episodes }
      context "when passing in valid aps", vcr: vcr_options do
        it "returns a 202" do
          request = described_class.new(Cassia::AccessController.new, aps: ["CC:1B:E0:E0:F1:E8"])

          response = request.perform

          expect(response).to be_truthy
        end
      end

    vcr_options = { cassette_name: 'close_connection_state/failure', record: :new_episodes }
      context "when passing invalid aps", vcr: vcr_options do
        it "returns a 400" do
          request = described_class.new(Cassia::AccessController.new, aps: ["invalid router mac"])

          response = request.perform

          expect(response).to be_falsey
        end
      end
  end
end
