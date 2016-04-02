if Rails.env.production?
  $redis_client = Redis.new(driver: :hiredis, host: ENV['REDIS_HOST'],
                            port: ENV['REDIS_PORT'],
                            password: ENV['REDIS_PASSWORD'])
  redis_conn = proc do
    Redis.new(driver: :hiredis, host: ENV['REDIS_HOST'],
              port: ENV['REDIS_PORT'],
              password: ENV['REDIS_PASSWORD'])
  end
else
  $redis_client = Redis.new(driver: :hiredis, host: ENV['REDIS_HOST'],
                            port: ENV['REDIS_PORT'])
  redis_conn = proc do
    Redis.new(driver: :hiredis, host: ENV['REDIS_HOST'],
              port: ENV['REDIS_PORT'])
  end
end
if Rails.env.test?
  $redis = Redis::Namespace.new('guclink_organizer', redis: $redis_client,
                                                     deprecations: true)
else
  $redis = Redis::Namespace.new('guclink', redis: $redis_client,
                                           deprecations: true)
end
Sidekiq.configure_client do |config|
  config.redis = ConnectionPool.new(size: 5, &redis_conn)
end
Sidekiq.configure_server do |config|
  config.redis = ConnectionPool.new(size: 25, &redis_conn)
end
