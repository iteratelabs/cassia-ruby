module Cassia
  class Api
    def post(request)
      connection.post do |req|
        req.url request.path
        req.headers = request.headers
        req.body = request.body
      end
    end

    def get(request)
      connection.get do |req|
        req.url request.path
        req.headers = request.headers
      end
    end

    def delete(request)
      connection.delete do |req|
        req.url request.path
        req.headers = request.headers
      end
    end

    private

    def connection
      @connection ||= Faraday.new(url: ac_url) do |faraday|
        faraday.response :logger, Cassia.logger, bodies: true
        faraday.response :json, :content_type => /\bjson$/
        faraday.adapter Faraday.default_adapter
        faraday.ssl.client_cert = OpenSSL::X509::Certificate.new(client_cert )if client_cert
        faraday.ssl.client_key = OpenSSL::PKey::RSA.new(client_key) if client_key
        faraday.ssl.ca_file = ca_file if ca_file
      end
    end

    def ac_url
      Cassia.configuration.ac_url
    end

    def client_cert
      Cassia.configuration.client_cert
    end

    def client_key
      Cassia.configuration.client_key
    end

    def ca_file
      Cassia.configuration.ca_file
    end
  end
end
