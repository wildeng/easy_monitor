# frozen_string_literal: true

require_dependency 'easy_monitor/application_controller'
require 'redis'

module EasyMonitor
  class CachingChecksController < ApplicationController
    protect_from_forgery

    def memcached_alive
      memcached_alive_message if memcached_alive?
    rescue EasyMonitor::Util::Errors::MemcachedNotWorking
      memcached_error_message
    rescue EasyMonitor::Util::Errors::MemcachedNotUsed
      memcached_not_setup_message
    end

    def redis_alive
      redis_alive_message if connect_to_redis
    rescue Redis::CannotConnectError
      redis_not_setup_message(EasyMonitor::Engine.redis_url)
    rescue StandardError => e
      redis_error_message(EasyMonitor::Engine.redis_url, e.message)
    end

    private

    def memcached_alive_message
      render json: { message: t('memcached.alive') }, status: 200
    end

    def memcached_not_setup_message
      log_message(t('memcached.not_set_up'))
      render json: {
        message: t('memcached.not_set_up')
      }, status: :service_unavailable
    end

    def memcached_error_message
      log_message(t('memcached.error'))
      render json: {
        message: t('memcached.error')
      }, status: :internal_server_error
    end

    def redis_alive_message
      render json: { message: t('redis.alive') }, status: 200
    end

    def redis_not_setup_message(redis_url)
      msg = t('redis.not_set_up', redis_url: redis_url )
      log_message(msg)
      render json: { message: msg  }, status: :service_unavailable
    end

    def redis_error_message(redis_url, message)
      msg = t('redis.error', redis_url: redis_url, message: message)
      log_message(msg)
      render json: { message: msg }, status: :internal_server_error
    end

    def connect_to_redis
      EasyMonitor.redis_ping
    end

    def memcached_alive?
      raise EasyMonitor::Util::Errors::MemcachedNotUsed\
        unless EasyMonitor::Engine.use_memcached
      raise EasyMonitor::Util::Errors::MemcachedNotWorking\
        unless EasyMonitor::Engine.cache

      EasyMonitor::Util::Connectors::MemcachedConnector.new(
        EasyMonitor::Engine.cache
      ).memcached_alive?
    end
  end
end
