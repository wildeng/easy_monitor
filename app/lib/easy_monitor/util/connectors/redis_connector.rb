# frozen_string_literal: true

# Singleton class that checks if
# a Redis instance is alive
#:nodoc: all
module EasyMonitor
  module Util
    module Connectors
      require 'singleton'
      require 'redis'

      class RedisConnector
        include Singleton

        attr_reader :connection

        def initialize
          @connection = new_connection
        end

        def ping
          @connection.ping
        end

        private

        def new_connection
          Redis.new(
            host: EasyMonitor::Engine.redis_url,
            port: EasyMonitor::Engine.redis_port
          )
        end
      end
    end
  end
end
