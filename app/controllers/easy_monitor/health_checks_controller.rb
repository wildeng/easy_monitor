# frozen_string_literal: true

require_dependency 'easy_monitor/application_controller'

#:nodoc
module EasyMonitor
  class HealthChecksController < ApplicationController
    protect_from_forgery

    # heartbeat of the application
    def alive
      render json: { message: t('alive') }, status: 200
    end

    # TODO: check the openapi specification and take a look if this is compliant
    def sidekiq_alive
      sidekiq_alive_message if connect_to_sidekiq
    rescue EasyMonitor::Util::Errors::HighLatencyError
      sidekiq_high_latency_message
    rescue EasyMonitor::Util::Errors::HighQueueNumberError
      sidekiq_high_queue_message
    rescue StandardError
      sidekiq_error_message
    end

    private

    def sidekiq_alive_message
      render json: {
        message: t('sidekiq.alive')
      }, status: 200
    end

    # returning a request timeout 504
    def sidekiq_high_latency_message
      log_message(t('sidekiq.high_latency'))
      render json: {
        message: t('sidekiq.high_latency')
      }, status: :request_timeout
    end

    def sidekiq_high_queue_message
      log_message(t('sidekiq.high_queue'))
      render json: {
        message: t('sidekiq.high_queue')
      }, status: 200
    end

    # return a 503 status code when not available
    def sidekiq_error_message
      log_message(t('sidekiq.not_set_up'))
      render json: {
        message: t('sidekiq.not_set_up')
      }, status: :service_unavailable
    end

    def connect_to_sidekiq
      EasyMonitor.sidekiq_alive?
    end
  end
end
