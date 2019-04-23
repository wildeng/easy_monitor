module EasyMonitor
  module Util
    module Connectors
      require 'singleton'
      require 'redis'
      
      class RedisConnector
        include Singleton
        
        def initialize
          @connection = new_connection
        end

        def ping
          @connection.ping
        end

        private

        def new_connection
          redis = Redis.new(
            host: EasyMonitor::Engine.redis_url,
            port: EasyMonitor::Engine.redis_port
          )
        end
      end
    end
  end
end
