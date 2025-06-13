require "jwt"

class JsonWebToken
  SECRET_KEY = ENV.fetch("JWT_SECRET_KEY") { "fallback_secret" }

  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY, "HS256")
  end

  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY, true, algorithm: "HS256")
    HashWithIndifferentAccess.new(decoded[0])
  rescue JWT::DecodeError => e
    raise StandardError.new("Invalid token: #{e.message}")
  end
end
