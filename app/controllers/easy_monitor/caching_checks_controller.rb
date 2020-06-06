# frozen_string_literal: true

require_dependency 'easy_monitor/application_controller'
require 'redis'

module EasyMonitor
  class CachingChecksController < ApplicationController
    protect_from_forgery

    def memcached_alive
      head :no_content if memcached_alive?
    rescue EasyMonitor::Util::Errors::MemcachedNotWorking
      log_message('Memcached is not available')
      head :service_unavailable
    rescue EasyMonitor::Util::Errors::MemcachedNotUsed
      log_message('Memcached is not set up')
      head :not_implemented
    end

    def redis_alive
      head :no_content if connect_to_redis
    rescue Redis::CannotConnectError
      log_message(
        "Redis server at #{EasyMonitor::Engine.redis_url} is not responding"
      )
      head :request_timeout
    rescue StandardError => e
      log_message(
        "An error occurred #{EasyMonitor::Engine.redis_url} #{e.message}"
      )
      head :request_timeout
    end

    private

    def connect_to_redis
      EasyMonitor.redis_ping
    end

    def memcached_alive?
      raise EasyMonitor::Util::Errors::MemcachedNotUsed
        unless EasyMonitor::Engine.use_memcached
      raise EasyMonitor::Util::Errors::MemcachedNotWorking
        unless EasyMonitor::Engine.cache

      EasyMonitor::Util::Connectors::MemcachedConnector.new(
        EasyMonitor::Engine.cache
      ).memcached_alive?
    end
  end
end
