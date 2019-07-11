require 'spec_helper'

RSpec.describe Cassia::ResponseHandlers::DiscoverDescriptorOfChar do
  include FaradayHelpers
  describe "#handle" do
    vcr_options = { cassette_name: 'ResHdlr_discover_descriptor_of_char/success', record: :new_episodes }
      context "when passing in a valid router, device_mac and char_uuid", vcr: vcr_options do
        it "returns true for a successful response" do
          access_controller = Cassia::AccessController.new
          response_body = [{"handle":3,"uuid":"00002a00-0000-1000-8000-00805f9b34fb"}]
          response = build_response(status: 200, body: response_body)
          router = Cassia::Router.new(mac: "CC:1B:E0:E0:F1:E8")
          connect_req = Cassia::Requests::ConnectLocal.new(access_controller, router: router, device_mac: "F6:12:3D:BD:DE:44", type: "random")
          connect_res = connect_req.perform
          char_req = Cassia::Requests::DiscoverAllChar.new(access_controller, router: router, device_mac: "F6:12:3D:BD:DE:44")
          char_res = char_req.perform
          response_handler = described_class.new(access_controller, router: router, device_mac: "F6:12:3D:BD:DE:44", char_uuid: "00002a00-0000-1000-8000-00805f9b34fb")
          
          result = response_handler.handle(response)

          expect(result). to be_truthy
        end
      end

    vcr_options = { cassette_name: 'ResHdlr_discover_descriptor_of_char/failure', record: :new_episodes }
      context "when passing in an invalid char_uuid", vcr: vcr_options do
        it "returns false for an unsuccessful response" do
          access_controller = Cassia::AccessController.new
          response_body = {}
          response = build_response(status: 200, body: response_body)
          router = Cassia::Router.new(mac: "CC:1B:E0:E0:F1:E8")
          connect_req = Cassia::Requests::ConnectLocal.new(access_controller, router: router, device_mac: "F6:12:3D:BD:DE:44", type: "random")
          connect_res = connect_req.perform
          char_req = Cassia::Requests::DiscoverAllChar.new(access_controller, router: router, device_mac: "F6:12:3D:BD:DE:44")
          char_res = char_req.perform
          response_handler = described_class.new(access_controller, router: router, device_mac: "F6:12:3D:BD:DE:44", char_uuid: "00002a00-0000-1000-8000-00805f9b34fb")
          
          result = response_handler.handle(response)

          expect(result). to be_falsey
        end
      end
  end
end
