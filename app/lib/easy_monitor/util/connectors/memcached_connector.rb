# frozen_string_literal: true

# class that checks if memcache is working
module EasyMonitor
  module Util
    module Connectors
      class MemcachedConnector
        attr_accessor :cache

        def initialize(cache)
          self.cache = cache
        end

        def memcached_alive?
          check_memcached
        end

        private

        def check_memcached
          return false unless cache.write('ping', 'pong')

          cache.read('ping') == 'pong'
        end
      end
    end
  end
end
