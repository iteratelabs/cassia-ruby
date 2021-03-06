require 'spec_helper'

RSpec.describe Cassia::ResponseHandlers::CloseNotify do
  include FaradayHelpers
  describe "#handle" do
    it "returns true for a successful response" do
      access_controller = Cassia::AccessController.new
      response_body = '{"status":"accepted"}'
      response = build_response(status: 202, body: response_body)
      response_handler = described_class.new(access_controller, aps: ["CC:1B:E0:E0:ED:AC", "CC:1B:E0:E0:F1:E8"])
      
      result = response_handler.handle(response)

      expect(result). to be_truthy
    end

    it "returns false for an unsuccessful response" do
      access_controller = Cassia::AccessController.new
      response_body = '{"status":"bad request","error":"invalid aps"}'
      response = build_response(status: 400, body: response_body)
      response_handler = described_class.new(access_controller, aps: ["CC:1B:E0:E0:ED:AC", "CC:1B:E0:E0:F1:E8"])
      
      result = response_handler.handle(response)

      expect(result). to be_falsey
    end
  end
end
