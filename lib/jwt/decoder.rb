module Jwt
  class Decoder
    ALGORITHM = "HS256".freeze

    def self.call(token)
      JWT.decode(
        token,
        secret_key,
        true,
        { algorithm: ALGORITHM }
      )
    end

    private

    def self.secret_key
      Rails.application.credentials[:JWT_SECRET_KEY]
    end
  end
end
