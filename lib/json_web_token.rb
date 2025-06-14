require "jwt"

# this class handles all the jwt token thing
# we use it to encode user data into a token, and decode it back
# it's simple, clean, and reusable, no need to overcomplicate it

class JsonWebToken
  # secret key used to sign the token
  # make sure to keep this secret in .env (never hardcode and check before pushing to github)
  SECRET_KEY = ENV.fetch("JWT_SECRET_KEY") { "fallback_secret" }

  # encode payload into a jwt
  # payload is usually like: { user_id: 1 }
  # exp = token expiration (default: 24 hours from now) => pick the time based on your need
  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
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
