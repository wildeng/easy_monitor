require 'mock_redis'

EasyMonitor::Engine.setup do |config|
  redis = MockRedis.new
  config.redis_url = redis.host
  config.redis_port = redis.port
end
