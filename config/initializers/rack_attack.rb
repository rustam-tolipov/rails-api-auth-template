class Rack::Attack
  # i added this to test r.a in dev mode
  # this tries to use MemoryStore cache if Redis is not present
  # kudos for this guy: honeybadger.io/blog/rails-api-rack-attack/
  if !ENV["REDIS_URL"] || Rails.env.test?
    cache.store = ActiveSupport::Cache::MemoryStore.new
  end

  # this is for limiting login attempts to 5 reqs every 20 secs per ip
  # and of course it's for preventing bture force ;)
  throttle("logins/ip", limit: 5, period: 20.seconds) do |req|
    req.ip if req.path == "/api/v1/login" && req.post?
  end

  # same thing for signup as well
  throttle("signups/ip", limit: 5, period: 60.seconds) do |req|
    req.ip if req.path == "/api/v1/signup" && req.post?
  end

  # why not tell them politely if they try too much
  self.throttled_response = lambda do |_env|
    [
      429,
      { "Content-Type" => "application/json" },
      [ { error: "too many requests. chill out and try again later." }.to_json ]
    ]
  end
end
