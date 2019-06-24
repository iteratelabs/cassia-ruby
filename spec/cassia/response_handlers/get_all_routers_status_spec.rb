require 'spec_helper'

RSpec.describe Cassia::ResponseHandlers::GetAllRoutersStatus do
  include FaradayHelpers
  describe "#handle" do
    it "returns true for a successful response" do
      access_controller = Cassia::AccessController.new
      response_body = [{"_id": "5cb8e45764390a003eb9304c","id": "CC:1B:E0:E0:ED:AC","mac": "CC:1B:E0:E0:ED:AC","name": "Cassia
      Router","group":"","status": "online","model": "E1000","version": "1.4.0.1901300130","position": "","time":1555620951936,"ip": "76.244.39.175","localip": "192.168.1.75","uptime": 746841,"offline_time": 1559770861,"online_time": 1559776211,"update_status": "update_ok","update_reason":"","update_version":"","update_progress":0,"container":{"status_code":6,"status": "not_exist"},"ap":{"uplink": "wired"}}]
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
