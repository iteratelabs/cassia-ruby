require 'spec_helper'

RSpec.describe Cassia::AccessController do
  include FaradayHelpers
  
  describe "#get_token" do
    vcr_options = { cassette_name: 'access_controller/get_token/success', record: :new_episodes }
      context "when successful", vcr: vcr_options do
        it "sets the access_token" do
          access_controller = described_class.new
          response_body = {"token_type"=>"bearer","access_token"=>"e18a98abddaf5a241dd528a0beaae9b387fd44a02efa01d4b7d71f30e7dc4456","expires_in"=>3600}
          response = build_response(status: 200, body: response_body)
          response_handler = Cassia::ResponseHandlers::GetToken.new(access_controller)
          response_handler.handle(response)
          expect(access_controller.access_token).to eq "e18a98abddaf5a241dd528a0beaae9b387fd44a02efa01d4b7d71f30e7dc4456"
        end
      end
    
    vcr_options = { cassette_name: 'access_controller/get_token/failure', record: :new_episodes }
      context "when unsuccessful" do
        it "sets the error and error_description values" do
          access_controller = described_class.new
          response_body = {"error": "invalid_client","error_description": "Client not found"}
          response = build_response(status: 401, body: response_body)
          response_handler = Cassia::ResponseHandlers::GetToken.new(access_controller)
          response_handler.handle(response)
          expect(access_controller.error). to eq "invalid_client"
          expect(access_controller.error_description). to eq "Client not found"
        end
      end
  end

  describe "#get_all_routers_status" do
    context "when unsuccessful" do
      it "sets the error and error_description values" do
        access_controller = described_class.new
        response_body = '{"error":"forbidden","error_description":"Token not found or expired"}'
        response = build_response(status: 403, body: response_body)
        response_handler = Cassia::ResponseHandlers::GetAllRoutersStatus.new(access_controller)
        response_handler.handle(response)
        expect(access_controller.error). to eq "forbidden"
        expect(access_controller.error_description). to eq "Token not found or expired"
      end
    end
  end

  describe "#switch_autoselect" do
    vcr_options = { cassette_name: 'access_controller/get_token/success_1', record: :new_episodes }
        context "when successfully switching to 1", vcr: vcr_options do
          it "sets the switch to 1" do
            access_controller = described_class.new
            response_body = {"status"=>"success","flag"=>1}
            response = build_response(status: 200, body: response_body)
            response_handler = Cassia::ResponseHandlers::SwitchAutoselect.new(access_controller)
            response_handler.handle(response)
            expect(access_controller.autoselect_switch).to eq 1
          end
        end

    vcr_options = { cassette_name: 'access_controller/get_token/success_0', record: :new_episodes }
        context "when successfully switching to 0", vcr: vcr_options do
          it "sets the switch to 0" do
            access_controller = described_class.new
            response_body = {"status"=>"success","flag"=>0}
            response = build_response(status: 200, body: response_body)
            response_handler = Cassia::ResponseHandlers::SwitchAutoselect.new(access_controller)
            response_handler.handle(response)
            expect(access_controller.autoselect_switch).to eq 0
          end
        end
  
    context "when unsuccessful" do
      it "sets the error and error_description values" do
        access_controller = described_class.new
        response_body = '{"error":"forbidden","error_description":"Token not found or expired"}'
        response = build_response(status: 403, body: response_body)
        response_handler = Cassia::ResponseHandlers::SwitchAutoselect.new(access_controller)
        response_handler.handle(response)
        expect(access_controller.error). to eq "forbidden"
        expect(access_controller.error_description). to eq "Token not found or expired"
      end
    end
  end

  describe "#open_scan" do
    context "when unsuccessful" do
      it "sets the error" do
        access_controller = described_class.new
        response_body = '{"status":"bad request","error":"invalid aps"}'
        response = build_response(status: 400, body: response_body)
        response_handler = Cassia::ResponseHandlers::OpenScan.new(access_controller)
        response_handler.handle(response)
        expect(access_controller.error). to eq "invalid aps"
      end
    end
  end

  describe "#connect_device" do
    context "when successful" do
      it "sets the device mac address" do
        access_controller = described_class.new
        response_body = {"status"=>"ok", "device"=>"F3:25:5F:22:35:39"}
        response = build_response(status: 200, body: response_body)
        response_handler = Cassia::ResponseHandlers::ConnectDevice.new(access_controller)
        response_handler.handle(response)
        expect(access_controller.device_mac).to eq "F3:25:5F:22:35:39"
      end
    end

    context "when unsuccessful" do
      it "sets the error" do
        access_controller = described_class.new
        response_body = {"status"=>"bad request", "error"=>"invalid devices"}
        response = build_response(status: 400, body: response_body)
        response_handler = Cassia::ResponseHandlers::ConnectDevice.new(access_controller)
        response_handler.handle(response)
        expect(access_controller.error). to eq "invalid devices"
      end
    end
  end
end
