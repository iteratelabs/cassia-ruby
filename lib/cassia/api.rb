module Cassia
  class Api
    def post(request)
      connection.post do |req|
        req.url request.path
        req.headers = request.headers
        req.body = request.body
      end
    end

    private

    def connection
      @connection ||= Faraday.new(url: ac_url)
    end

    def ac_url
      "#{Cassia.configuration.ac_url}/api"
    end
  end
end