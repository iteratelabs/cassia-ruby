require 'spec_helper'

RSpec.describe Cassia::ResponseHandlers::DisconnectDevice do
  include FaradayHelpers
  describe "#handle" do
    it "returns true for a successful response" do
      access_controller = Cassia::AccessController.new
      response_body = {"status"=>"ok", "device"=>"F3:25:5F:22:35:39"}
      response = build_response(status: 200, body: response_body)
      response_handler = described_class.new(access_controller)
      
      result = response_handler.handle(response)

      expect(result). to be_truthy
    end

    it "returns false for an unsuccessful response" do
      access_controller = Cassia::AccessController.new
      response_body = {"status"=>"bad request", "error"=>"invalid devices"}
      response = build_response(status: 400, body: response_body)
      response_handler = described_class.new(access_controller)
      
      result = response_handler.handle(response)

      expect(result). to be_falsey
    end
  end
end
