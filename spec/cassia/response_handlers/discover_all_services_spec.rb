require 'spec_helper'

RSpec.describe Cassia::ResponseHandlers::DiscoverAllServices do
  include FaradayHelpers
  describe "#handle" do
    vcr_options = { cassette_name: 'ResHdlr_discover_all_services/success', record: :new_episodes }
      context "when passing in a valid router and device_mac", vcr: vcr_options do
        it "returns true for a successful response" do
          access_controller = Cassia::AccessController.new
          response_body = [{"uuid":"00001800-0000-1000-8000-00805f9b34fb","primary":true,"handle":1},{"uuid":"00001801-0000-1000-8000-00805f9b34fb","primary":true,"handle":10},{"uuid":"6e400001-b5a3-f393-e0a9-e50e24dcca9e","primary":true,"handle":11}]
          response = build_response(status: 200, body: response_body)
          router = Cassia::Router.new(mac: "CC:1B:E0:E0:F1:E8")
          connect_req = Cassia::Requests::ConnectLocal.new(access_controller, router: router, device_mac: "F6:12:3D:BD:DE:44", type: "random")
          connect_res = connect_req.perform
          response_handler = described_class.new(access_controller, router: router, device_mac: "F6:12:3D:BD:DE:44" )
          
          result = response_handler.handle(response)

          expect(result). to be_truthy
        end
      end

    vcr_options = { cassette_name: 'ResHdlr_discover_all_services/failure', record: :new_episodes }
      context "when passing in a valid router and device_mac", vcr: vcr_options do
        it "returns false for an unsuccessful response" do
          access_controller = Cassia::AccessController.new
          response_body = "parameter invalid"
          response = build_response(status: 500, body: response_body)
          router = Cassia::Router.new(mac: "CC:1B:E0:E0:F1:E8")
          connect_req = Cassia::Requests::ConnectLocal.new(access_controller, router: router, device_mac: "F6:12:3D:BD:DE:44", type: "random")
          connect_res = connect_req.perform
          response_handler = described_class.new(access_controller, router: router, device_mac: "F6:12:3D:BD:DE:44" )
          
          result = response_handler.handle(response)

          expect(result). to be_falsey
        end
      end
  end
end
