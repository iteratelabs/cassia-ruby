require "faraday"
require "faraday_middleware"
require "base64"
require "json"

require "cassia/api"
require "cassia/configuration"
require "cassia/default_logger"
require "cassia/requests/get_token"
require "cassia/requests/get_all_routers_status"
require "cassia/requests/switch_autoselect"
require "cassia/requests/open_scan"

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
