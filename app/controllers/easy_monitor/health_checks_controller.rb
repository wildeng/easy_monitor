require_dependency 'easy_monitor/application_controller'
require 'redis'

module EasyMonitor
  class HealthChecksController < ApplicationController
    protect_from_forgery

    before_action :basic_authentication

    def alive
      head :no_content
    end

    def redis_alive
      head :no_content if connect_to_redis
    rescue StandardError
      logger.error(
        "Redis server at #{EasyMonitor::Engine.redis_url} is not responding"
      )
      head :request_timeout
    end

    def sidekiq_alive; end

    private

    def basic_authentication
      # TODO: implements a basic authentication related to the calling app
      true
    end

    def connect_to_redis
      EasyMonitor.redis_ping
    end
  end
end
