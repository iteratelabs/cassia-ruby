module Cassia
  class AccessController
    include Virtus.model

    attribute :access_token, String
    attribute :error, String
    attribute :error_description, String

    def get_token
      Cassia::Requests::GetToken.new(self).perform
    end
  end
end
