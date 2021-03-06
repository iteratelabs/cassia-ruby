require 'spec_helper'

RSpec.describe Cassia::ResponseHandlers::WriteCharByHandle do
  include FaradayHelpers
  describe "#handle" do
    vcr_options = { cassette_name: 'ResHdlr_write_char_by_handle/success', record: :new_episodes }
    context "when passing in valid params", vcr: vcr_options do
      it "returns true for a successful response" do
        access_controller = Cassia::AccessController.new
        response_body = "OK"
        response = build_response(status: 200, body: response_body)
        router = Cassia::Router.new(mac: "CC:1B:E0:E0:F1:E8")
        connect_req = Cassia::Requests::ConnectLocal.new(access_controller, router: router, device_mac: "F6:12:3D:BD:DE:44", type: "random")
        connect_res = connect_req.perform
        char_req = Cassia::Requests::DiscoverAllChar.new(access_controller, router: router, device_mac: "F6:12:3D:BD:DE:44")
        char_res = char_req.perform
        response_handler = described_class.new(access_controller, router: router, device_mac: "F6:12:3D:BD:DE:44", handle: 3, value: "0100" )

        result = response_handler.handle(response)

        expect(result). to be_truthy
      end
    end

    vcr_options = { cassette_name: 'ResHdlr_write_char_by_handle/failure', record: :new_episodes }
    context "when passing in an invalid handle", vcr: vcr_options do
      it "returns false for an unsuccessful response" do
        access_controller = Cassia::AccessController.new
        response_body = "OK"
        response = build_response(status: 200, body: response_body)
        router = Cassia::Router.new(mac: "CC:1B:E0:E0:F1:E8")
        connect_req = Cassia::Requests::ConnectLocal.new(access_controller, router: router, device_mac: "F6:12:3D:BD:DE:44", type: "random")
        connect_res = connect_req.perform
        char_req = Cassia::Requests::DiscoverAllChar.new(access_controller, router: router, device_mac: "F6:12:3D:BD:DE:44")
        char_res = char_req.perform
        response_handler = described_class.new(access_controller, router: router, device_mac: "F6:12:3D:BD:DE:44", handle: 100, value: "32" )

        result = response_handler.handle(response)

        expect(result). to be_falsey
      end
    end

    context "when handling an unsuccessful request" do
      it "returns false" do
        access_controller = Cassia::AccessController.new
        router = Cassia::Router.new(mac: "CC:1B:E0:E0:F1:E8")
        response = build_response(status: 500, body: {error: 'Error message'}.to_json)

        response_handler = described_class.new(access_controller, router: router, device_mac: "F6:12:3D:BD:DE:44", handle: 100, value: "32" )

        result = response_handler.handle(response)

        expect(result). to be_falsey
      end

      it "sets the error on the access controller" do
        access_controller = Cassia::AccessController.new
        router = Cassia::Router.new(mac: "CC:1B:E0:E0:F1:E8")
        response = build_response(status: 500, body: 'device disconnect')

        response_handler = described_class.new(access_controller, router: router, device_mac: "F6:12:3D:BD:DE:44", handle: 100, value: "32" )

        result = response_handler.handle(response)

        expect(access_controller.error). to eq('device disconnect')
      end
    end
  end
end
