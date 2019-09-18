module Cassia
  class Configuration
    attr_accessor :client_id, :secret, :ac_url, :client_cert, :client_key, :ca_file

    def ac_url
    	@ac_url ||= "http://demo.cassia.pro"
    end
  end
end
