require 'spec_helper'

RSpec.describe Cassia::ResponseHandlers::GetToken do
  include FaradayHelpers
  describe "#handle" do
    it "returns true for a successful response" do
      access_controller = Cassia::AccessController.new
      response_body = {"token_type": "bearer","access_token": "e18a98abddaf5a241dd528a0beaae9b387fd44a02efa01d4b7d71f30e7dc4456","expires_in": 3600}
      response = build_response(status: 200, body: response_body)
      response_handler = described_class.new(access_controller)
      
      result = response_handler.handle(response)

      expect(result). to be_truthy
    end

    it "returns false for an unsuccessful response" do
      access_controller = Cassia::AccessController.new
      response_body = {"error": "invalid_client","error_description": "Client not found"}
      response = build_response(status: 401, body: response_body)
      response_handler = described_class.new(access_controller)
      
      result = response_handler.handle(response)

      expect(result). to be_falsey
    end
  end
end
