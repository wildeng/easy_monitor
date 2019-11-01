require_dependency 'easy_monitor/application_controller'
require 'redis'
require 'rotp'

#:nodoc
module EasyMonitor
  class HealthChecksController < ApplicationController
    protect_from_forgery

    before_action :check_totp_code, if: :totp_required?

    # heartbeat of the application
    def alive
      head :no_content
    end

    def memcached_alive
      head :no_content if memcached_alive?    
    rescue EasyMonitor::Util::Errors::MemcachedNotWorking
      EasyMonitor::Engine.logger.error(
        "Memcached is not working"
      )
      head :service_unavailable
    rescue EasyMonitor::Util::Errors::MemcachedNotUsed
      EasyMonitor::Engine.logger.error(
        "Memcached is not set up"
      )
      head :not_implemented
    end
    
    def redis_alive
      head :no_content if connect_to_redis
    rescue Redis::CannotConnectError
      EasyMonitor::Engine.logger.error(
        "Redis server at #{EasyMonitor::Engine.redis_url} is not responding"
      )
      head :request_timeout
    rescue StandardError => e
      EasyMonitor::Engine.logger.error(
        "An error occurred #{EasyMonitor::Engine.redis_url} #{e.message}"
      )
      head :request_timeout
    end

    def sidekiq_alive
      head :no_content if connect_to_sidekiq
    rescue EasyMonitor::Util::Errors::HighLatencyError
      EasyMonitor::Engine.logger.error('Sidekiq is experiencing a high latency')
      head :request_timeout
    rescue EasyMonitor::Util::Errors::HighQueueNumberError
      EasyMonitor::Engine.logger.error('Too many jobs enqueued in Sidekiq')
      head :request_timeout
    rescue StandardError
      EasyMonitor::Engine.logger.error('Sidekiq is not responding or not set')
      head :request_timeout
    end

    private

    def connect_to_redis
      EasyMonitor.redis_ping
    end

    def connect_to_sidekiq
      EasyMonitor.sidekiq_alive?
    end

    def check_totp_code
      return head :unauthorized unless params[:totp_code]
      totp = ROTP::TOTP.new(EasyMonitor::Engine.totp_secret)
      head :unauthorized unless totp.verify(params[:totp_code])
    end

    def memcached_alive?
      raise EasyMonitor::Util::Errors::MemcachedNotUsed unless EasyMonitor::Engine.use_memcached
      raise EasyMonitor::Util::Errors::MemcachedNotWorking unless EasyMonitor::Engine.cache
      EasyMonitor::Util::Connectors::MemcachedConnector.new(
        EasyMonitor::Engine.cache
      ).memcached_alive?
    end

    def totp_required?
      EasyMonitor::Engine.use_totp
    end
  end
end
