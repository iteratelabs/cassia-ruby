module Cassia
  class Configuration
    attr_accessor :client_id, :secret, :ac_url
 
    def ac_url
    	@ac_url ||= "http://demo.cassia.pro"
    end
  end
end
