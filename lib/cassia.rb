require "faraday"
require "base64"
require "json"

require "cassia/api"
require "cassia/configuration"
require "cassia/requests/get_token"

module Cassia
  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.api
    @api ||= Api.new
  end

  def self.configure
    yield(configuration)
  end
end
