require 'spec_helper'

RSpec.describe Cassia::Requests::SwitchAutoselect do
  describe '#path' do
    it "returns the correct API endpoint" do
      request = described_class.new(Cassia::AccessController.new)

      expect(request.path).to eq('/api/aps/ap-select-switch')
    end
  end

  describe '#body' do
    it "returns the correct flag for an on_request" do
      on_request = described_class.new(Cassia::AccessController.new, flag: 1)

      expect(on_request.body).to eq(
        {
          'flag' => 1
        }.to_json
      )
    end

    it "returns the correct flag for an off_request" do
      off_request = described_class.new(Cassia::AccessController.new, flag: 0)
      
      expect(off_request.body).to eq(
        {
          'flag' => 0
        }.to_json
      )
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
    vcr_options = { cassette_name: 'switch_autoselect/success_on', record: :new_episodes }
    context "when passing a valid access token to an on_request", vcr: vcr_options do
      it "returns a 200 response for an on_request" do
        Cassia.configuration.client_id = ENV['CASSIA_CLIENT_ID']
        Cassia.configuration.secret = ENV['CASSIA_SECRET']
        access_controller = Cassia::AccessController.new
        request = described_class.new(access_controller, flag: 1)

        response = request.perform
        
        expect(response).to be_truthy
      end
    end

    vcr_options = { cassette_name: 'switch_autoselect/success_off', record: :new_episodes }
    context "when passing a valid access token to an off_request", vcr: vcr_options do
      it "returns a 200 response for an off_request" do
        Cassia.configuration.client_id = ENV['CASSIA_CLIENT_ID']
        Cassia.configuration.secret = ENV['CASSIA_SECRET']
        access_controller = Cassia::AccessController.new
        request2 = described_class.new(access_controller, flag: 0)

        response2 = request2.perform

        expect(response2).to be_truthy
      end
    end

    vcr_options = { cassette_name: 'switch_autoselect/failure', record: :new_episodes }
    context "when passing an invalid access token", vcr: vcr_options do
      it "returns a 403" do
        access_controller = Cassia::AccessController.new
        access_controller.access_token = "invalid_access_token"
        request = described_class.new(access_controller)
        
        response = request.perform

        expect(response).to be_falsey
      end
    end
  end
end
