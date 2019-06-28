require 'spec_helper'

RSpec.describe Cassia::ResponseHandlers::ConnectLocal do
  include FaradayHelpers
  describe "#handle" do
    it "returns true for a successful response" do
      access_controller = Cassia::AccessController.new
      response_body = "OK"
      response = build_response(status: 200, body: response_body)
      router = Cassia::Router.new(mac: "CC:1B:E0:E0:F1:E8")
      response_handler = described_class.new(access_controller, router: router, device_mac: "F6:12:3D:BD:DE:44" )
      
      result = response_handler.handle(response)

      expect(result). to be_truthy
    end

    it "returns false for an unsuccessful response" do
      access_controller = Cassia::AccessController.new
      response_body = "timeout"
      response = build_response(status: 400, body: response_body)
      router = Cassia::Router.new(mac: "CC:1B:E0:E0:F1:E8")
      response_handler = described_class.new(access_controller, router: router, device_mac: "F6:12:3D:BD:DE:44" )
      
      result = response_handler.handle(response)

      expect(result). to be_falsey
    end
  end
end
