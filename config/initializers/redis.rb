env_num = Rails.env.production? ? 0 : 1
Redis.new(db: env_num) # existing DB is selected if already present

$redis = Redis.new(url: ENV["REDISCLOUD_URL"])
