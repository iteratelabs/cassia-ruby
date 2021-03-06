require "faraday"
require "faraday_middleware"
require "virtus"
require "base64"
require "json"
require "ld-eventsource"

require "cassia/api"
require "cassia/configuration"
require "cassia/default_logger"
require "cassia/descriptor"
require "cassia/characteristic"
require "cassia/service"
require "cassia/device"
require "cassia/router"
require "cassia/access_controller"
require "cassia/response_handlers/get_token"
require "cassia/response_handlers/get_all_routers_status"
require "cassia/response_handlers/switch_autoselect"
require "cassia/response_handlers/open_scan"
require "cassia/response_handlers/close_scan"
require "cassia/response_handlers/connect_device"
require "cassia/response_handlers/disconnect_device"
require "cassia/response_handlers/connect_local"
require "cassia/response_handlers/disconnect_local"
require "cassia/response_handlers/get_connected_devices_router"
require "cassia/response_handlers/open_notify"
require "cassia/response_handlers/close_notify"
require "cassia/response_handlers/open_connection_state"
require "cassia/response_handlers/close_connection_state"
require "cassia/response_handlers/open_ap_state"
require "cassia/response_handlers/close_ap_state"
require "cassia/response_handlers/discover_all_services"
require "cassia/response_handlers/discover_all_char"
require "cassia/response_handlers/discover_char_of_service"
require "cassia/response_handlers/discover_descriptor_of_char"
require "cassia/response_handlers/discover_all_services_and_chars"
require "cassia/response_handlers/write_char_by_handle"
require "cassia/requests/get_token"
require "cassia/requests/get_all_routers_status"
require "cassia/requests/switch_autoselect"
require "cassia/requests/open_scan"
require "cassia/requests/close_scan"
require "cassia/requests/connect_device"
require "cassia/requests/disconnect_device"
require "cassia/requests/connect_local"
require "cassia/requests/disconnect_local"
require "cassia/requests/get_connected_devices_router"
require "cassia/requests/open_notify"
require "cassia/requests/close_notify"
require "cassia/requests/open_connection_state"
require "cassia/requests/close_connection_state"
require "cassia/requests/open_ap_state"
require "cassia/requests/close_ap_state"
require "cassia/requests/combined_sse"
require "cassia/requests/discover_all_services"
require "cassia/requests/discover_all_char"
require "cassia/requests/discover_char_of_service"
require "cassia/requests/discover_descriptor_of_char"
require "cassia/requests/discover_all_services_and_chars"
require "cassia/requests/write_char_by_handle"

module Cassia
  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.api
    @api ||= Api.new
  end

  def self.logger
    @logger ||= DefaultLogger.build
  end

  def self.logger=(logger)
    @logger = logger
  end

  def self.configure
    yield(configuration)
  end
end
