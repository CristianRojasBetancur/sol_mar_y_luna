module Jwt
  class Encoder
    ALGORITHM = "HS256".freeze

    def self.call(payload)
      JWT.encode(
        payload,
        secret_key,
        ALGORITHM,
        headers
      )
    end

    private

    def self.secret_key
      Rails.application.credentials[:JWT_SECRET_KEY]
    end

    def self.headers
      { typ: "JWT", alg: ALGORITHM }
    end
  end
end
