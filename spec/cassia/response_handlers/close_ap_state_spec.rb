require 'spec_helper'

RSpec.describe Cassia::ResponseHandlers::CloseAPState do
  include FaradayHelpers
  describe "#handle" do
    it "returns true for a successful response" do
      access_controller = Cassia::AccessController.new
      response_body = '{"status":"accepted"}'
      response = build_response(status: 202, body: response_body)
      response_handler = described_class.new(access_controller)
      
      result = response_handler.handle(response)

      expect(result). to be_truthy
    end

    it "returns false for an unsuccessful response" do
      access_controller = Cassia::AccessController.new
      response_body = '{"error":"access_denied","error_description":"Wrong authorization header"}'
      response = build_response(status: 403, body: response_body)
      response_handler = described_class.new(access_controller)
      
      result = response_handler.handle(response)

      expect(result). to be_falsey
    end
  end
end
