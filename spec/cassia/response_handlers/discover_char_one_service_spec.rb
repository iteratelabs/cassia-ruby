require 'spec_helper'

RSpec.describe Cassia::ResponseHandlers::DiscoverCharOneService do
  include FaradayHelpers
  describe "#handle" do
    vcr_options = { cassette_name: 'ResHdlr_discover_char_one_service/success', record: :new_episodes }
      context "when passing in a valid router, device_mac and service_uuid", vcr: vcr_options do
        it "returns true for a successful response" do
          access_controller = Cassia::AccessController.new
          response_body = [{"handle":3,"properties":10,"uuid":"00002a00-0000-1000-8000-00805f9b34fb"},{"handle":5,"properties":2,"uuid":"00002a01-0000-1000-8000-00805f9b34fb"},{"handle":7,"properties":2,"uuid":"00002a04-0000-1000-8000-00805f9b34fb"},{"handle":9,"properties":2,"uuid":"00002aa6-0000-1000-8000-00805f9b34fb"},{"handle":13,"properties":16,"uuid":"6e400003-b5a3-f393-e0a9-e50e24dcca9e"},{"handle":16,"properties":12,"uuid":"6e400002-b5a3-f393-e0a9-e50e24dcca9e"}]
          response = build_response(status: 200, body: response_body)
          router = Cassia::Router.new(mac: "CC:1B:E0:E0:F1:E8")
          connect_req = Cassia::Requests::ConnectLocal.new(access_controller, router: router, device_mac: "F6:12:3D:BD:DE:44", type: "random")
          connect_res = connect_req.perform
          service_req = Cassia::Requests::DiscoverAllServices.new(access_controller, router: router, device_mac: "F6:12:3D:BD:DE:44")
          service_res = service_req.perform
          response_handler = described_class.new(access_controller, router: router, device_mac: "F6:12:3D:BD:DE:44", service_uuid: "00001800-0000-1000-8000-00805f9b34fb")
          
          result = response_handler.handle(response)

          expect(result). to be_truthy
        end
      end

    vcr_options = { cassette_name: 'ResHdlr_discover_char_one_service/failure', record: :new_episodes }
      context "when passing in an invalid service_uuid", vcr: vcr_options do
        it "returns false for an unsuccessful response" do
          access_controller = Cassia::AccessController.new
          response_body = "Service Not Found"
          response = build_response(status: 500, body: response_body)
          router = Cassia::Router.new(mac: "CC:1B:E0:E0:F1:E8")
          connect_req = Cassia::Requests::ConnectLocal.new(access_controller, router: router, device_mac: "F6:12:3D:BD:DE:44", type: "random")
          connect_res = connect_req.perform
          service_req = Cassia::Requests::DiscoverAllServices.new(access_controller, router: router, device_mac: "F6:12:3D:BD:DE:44")
          service_res = service_req.perform
          response_handler = described_class.new(access_controller, router: router, device_mac: "F6:12:3D:BD:DE:44", service_uuid: "11001800-0000-1000-8000-00805f9b34fb")
          
          result = response_handler.handle(response)

          expect(result). to be_falsey
        end
      end
  end
end
