require 'spec_helper'

RSpec.describe Cassia::ResponseHandlers::OpenScan do
  include FaradayHelpers
  describe "#handle" do
    it "returns true for a successful response" do
      access_controller = Cassia::AccessController.new
      response_body = '{"status":"accepted"}'
      response = build_response(status: 200, body: response_body)
      response_handler = described_class.new(access_controller)
      
      expect(response_handler.handle(response)). to be_truthy
    end

    it "returns false for an unsuccessful response" do
      access_controller = Cassia::AccessController.new
      response_body = '{"status":"bad request","error":"invalid aps"}'
      response = build_response(status: 400, body: response_body)
      response_handler = described_class.new(access_controller)
      
      expect(response_handler.handle(response)). to be_falsey
    end
  end
end
