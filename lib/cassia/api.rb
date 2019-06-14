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

    private

    def connection
      @connection ||= Faraday.new(url: ac_url) do |faraday|
        faraday.response :logger, Cassia.logger, bodies: true
        faraday.response :json, :content_type => /\bjson$/
        faraday.adapter Faraday.default_adapter
      end
    end

    def ac_url
      Cassia.configuration.ac_url
    end
  end
end
