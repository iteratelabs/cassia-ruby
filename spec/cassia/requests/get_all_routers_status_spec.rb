require 'spec_helper'

RSpec.describe Cassia::Requests::GetAllRoutersStatus do
  describe '#path' do
    it "returns the correct API endpoint" do
      request = described_class.new(Cassia::AccessController.new)

      expect(request.path).to eq('/api/cassia/hubs')
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
    vcr_options = { cassette_name: 'routersstatus/success', record: :new_episodes }
    context "when passing valid credentials", vcr: vcr_options do
      it "returns true" do
        access_controller = Cassia::AccessController.new
        request = described_class.new(access_controller)

        response = request.perform

        expect(response).to be_truthy
      end
    end

    vcr_options = { cassette_name: 'routersstatus/failure', record: :new_episodes }
    context "when passing invalid access token", vcr: vcr_options do
      it "returns false" do
        access_controller = Cassia::AccessController.new
        access_controller.access_token = "invalid_access_token"
        request = described_class.new(access_controller)

        response = request.perform

        expect(response).to be_falsey
      end
    end
  end
end
