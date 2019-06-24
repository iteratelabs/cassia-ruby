require 'spec_helper'

RSpec.describe Cassia::ResponseHandlers::SwitchAutoselect do
  include FaradayHelpers
  describe "#handle" do
    it "returns true for a successful response" do
      access_controller = Cassia::AccessController.new
      response_body = {"status":"success","flag":1}
      response = build_response(status: 200, body: response_body)
      response_handler = described_class.new(access_controller)
      
      expect(response_handler.handle(response)). to be_truthy
    end

    it "returns false for an unsuccessful response" do
      access_controller = Cassia::AccessController.new
      response_body = '{"error":"forbidden","error_description":"Token not found or expired"}'
      response = build_response(status: 403, body: response_body)
      response_handler = described_class.new(access_controller)
      
      expect(response_handler.handle(response)). to be_falsey
    end
  end
end
