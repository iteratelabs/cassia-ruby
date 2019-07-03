require 'spec_helper'

RSpec.describe Cassia::Requests::OpenAPState do
  describe '#path' do
    it "returns the correct API endpoint" do
      request = described_class.new(Cassia::AccessController.new)

      expect(request.path).to eq('/api/aps/ap-state/open')
    end
  end

  describe '#headers' do
    it "returns the correct authorization and content-type" do
      access_controller = Cassia::AccessController.new
      access_controller.access_token = "2ded2d8cf3073d368fec27243a71f858e9b9231d7388e63e6d2f70852c33e66f"
      request = described_class.new(access_controller)

      expect(request.headers).to eq(
        {
          'Authorization' => "Bearer #{access_controller.access_token}",
          'Content-Type' => "application/json"
        }
      )
    end
  end

  describe '#perform' do
    vcr_options = { cassette_name: 'open_ap_state/success', record: :new_episodes }
      context "when passing in valid aps", vcr: vcr_options do
        it "returns a 202" do
          Cassia.configuration.client_id = ENV['CASSIA_CLIENT_ID']
          Cassia.configuration.secret = ENV['CASSIA_SECRET']
          request = described_class.new(Cassia::AccessController.new)
          
          response = request.perform

          expect(response).to be_truthy
        end
      end

    vcr_options = { cassette_name: 'open_ap_state/failure', record: :new_episodes }
      context "when passing invalid aps", vcr: vcr_options do
        it "returns a 400" do
          Cassia.configuration.client_id = "invalid client id"
          Cassia.configuration.secret = "invalid secret"
          request = described_class.new(Cassia::AccessController.new)
          
          response = request.perform

          expect(response).to be_falsey
        end
      end
  end
end
