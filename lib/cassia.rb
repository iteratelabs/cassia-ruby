require "faraday"
require "faraday_middleware"
require "virtus"
require "base64"
require "json"

require "cassia/api"
require "cassia/configuration"
require "cassia/default_logger"
require "cassia/router"
require "cassia/device"
require "cassia/access_controller"
require "cassia/response_handlers/get_token"
require "cassia/response_handlers/get_all_routers_status"
require "cassia/response_handlers/switch_autoselect"
require "cassia/response_handlers/open_scan"
require "cassia/response_handlers/connect_device"
require "cassia/requests/get_token"
require "cassia/requests/get_all_routers_status"
require "cassia/requests/switch_autoselect"
require "cassia/requests/open_scan"
require "cassia/requests/connect_device"

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
