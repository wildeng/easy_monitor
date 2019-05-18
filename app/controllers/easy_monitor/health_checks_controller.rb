require_dependency 'easy_monitor/application_controller'
require 'redis'
#:nodoc
module EasyMonitor
  class HealthChecksController < ApplicationController
    protect_from_forgery

    before_action :basic_authentication
    logger = EasyMonitor::Logger.log
    logger.formatter = EasyMonitor::Util::Formatters::LogFormatter.new

    def alive
      head :no_content
    end

    def redis_alive
      head :no_content if connect_to_redis
    rescue Redis::CannotConnectError
      logger.error(
        "Redis server at #{EasyMonitor::Engine.redis_url} is not responding"
      )
      head :request_timeout
    rescue StandardError => e
      logger.error(
        "An error occurred #{EasyMonitor::Engine.redis_url} #{e.message}"
      )
      head :request_timeout
    end

    def sidekiq_alive
      head :no_content if connect_to_sidekiq
    rescue EasyMonitor::Util::Errors::HighLatencyError
      logger.error( 'Sidekiq is experiencing a high latency')
      head :request_timeout
    rescue EasyMonitor::Util::Errors::HighQueueNumberError
      logger.error( 'Too many jobs enqueued in Sidekiq' )
      head :request_timeout
    rescue StandardError => e
      logger.error('Sidekiq is not responding or not set')
      head :request_timeout
    end

    private

    def basic_authentication
      # TODO: need to implement a clever way of
      true
    end

    def connect_to_redis
      EasyMonitor.redis_ping
    end

    def connect_to_sidekiq
      EasyMonitor.sidekiq_alive?
    end
  end
end
