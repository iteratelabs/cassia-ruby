require 'spec_helper'

RSpec.describe Cassia::Requests::CloseApState do
  include EnvironmentHelpers

  describe '#path' do
    it "returns the correct API endpoint" do
      request = described_class.new(Cassia::AccessController.new)

      expect(request.path).to eq('/api/aps/ap-state/close')
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
    vcr_options = { cassette_name: 'close_ap_state/success', record: :new_episodes }
      context "when passing in valid aps", vcr: vcr_options do
        it "returns a 202" do
          request = described_class.new(Cassia::AccessController.new)

          response = request.perform

          expect(response).to be_truthy
        end
      end

    vcr_options = { cassette_name: 'close_ap_state/failure', record: :new_episodes }
      context "when passing invalid aps", vcr: vcr_options do
        it "returns a 403" do
          with_environment('CASSIA_CLIENT_ID' => 'invalid client id', 'CASSIA_SECRET' => 'invalid secret') do
            Cassia.configuration.client_id = "invalid client id"
            Cassia.configuration.secret = "invalid secret"
            request = described_class.new(Cassia::AccessController.new)

            response = request.perform

            expect(response).to be_falsey
          end
        end
      end
  end
end
