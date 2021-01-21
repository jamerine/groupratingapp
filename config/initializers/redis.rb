$redis  = Redis.new(url: ENV["REDISCLOUD_URL"], db: Rails.env.production? ? 0 : 1, namespace: "groupratingapp_#{Rails.env}")
