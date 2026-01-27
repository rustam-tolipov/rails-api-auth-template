require "jwt"

# this class handles all the jwt token thing
# we use it to encode user data into a token, and decode it back
# it's simple, clean, and reusable, no need to overcomplicate it

class JsonWebToken
  # secret key used to sign the token
  # make sure to keep this secret in .env (never hardcode and check before pushing to github)
  # will crash if JWT_SECRET_KEY is not set - this is intentional for security
  SECRET_KEY = ENV.fetch("JWT_SECRET_KEY")

  # encode payload into a jwt
  # payload is usually like: { user_id: 1 }
  # exp = token expiration (default: 1 hour from now for better security)
  # jti = unique token identifier for blacklisting
  def self.encode(payload, exp = 1.hour.from_now)
    payload[:exp] = exp.to_i
    payload[:jti] ||= SecureRandom.uuid
    JWT.encode(payload, SECRET_KEY, "HS256")
  end

  # decode jwt back into original payload
  # returns the payload if token is valid, else it throws error
  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY, true, algorithm: "HS256")
    HashWithIndifferentAccess.new(decoded[0])
  rescue JWT::DecodeError => e
    # if decoding fails, basic error raises so you can add yours as well
    raise StandardError.new("Invalid token: #{e.message}")
  end
end
