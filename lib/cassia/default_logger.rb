require 'logger'

module Cassia
  class DefaultLogger
    def self.build
      Logger.new(STDOUT).tap do |logger|
        logger.level = Logger::INFO
      end
    end
  end
end
