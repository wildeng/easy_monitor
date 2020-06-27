# frozen_string_literal: true

require_dependency 'easy_monitor/application_controller'

#:nodoc
module EasyMonitor
  class HealthChecksController < ApplicationController
    protect_from_forgery

    # heartbeat of the application
    def alive
      render json: { message: 'System is alive' }, status: 200
    end

    # TODO: check the openapi specification and take a look if this is compliant
    def sidekiq_alive
      sidekiq_alive_message if connect_to_sidekiq
    rescue EasyMonitor::Util::Errors::HighLatencyError
      EasyMonitor::Engine.logger.error('Sidekiq is experiencing a high latency')
      sidekiq_high_latency_message
    rescue EasyMonitor::Util::Errors::HighQueueNumberError
      EasyMonitor::Engine.logger.error('Too many jobs enqueued in Sidekiq')
      sidekiq_high_queue_message
    rescue StandardError
      EasyMonitor::Engine.logger.error('Sidekiq is not responding or not set')
      sidekiq_error_message
    end

    private

    def sidekiq_alive_message
      render json: {
        message: 'Sidekiq is alive'
      }, status: 200
    end

    # returning a request timeout 504
    def sidekiq_high_latency_message
      render json: {
        message: 'Sidekiq is experiencing a high latency'
      }, status: :request_timeout
    end

    def sidekiq_high_queue_message
      render json: {
        message: 'Too many jobs enqueued in Sidekiq'
      }, status: 200
    end

    # return a 503 status code when not available
    def sidekiq_error_message
      render json: {
        message: 'Sidekiq is not responding or not set'
      }, status: :service_unavailable
    end

    def connect_to_sidekiq
      EasyMonitor.sidekiq_alive?
    end
  end
end
