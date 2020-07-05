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

    def active_record_alive
      active_record_alive_message if active_record_connection
      active_record_not_alive_message unless active_record_connection
    rescue
      active_record_not_set_up
    end

    # TODO: check the openapi specification and take a look if this is compliant
    def sidekiq_alive
      sidekiq_alive_message if connect_to_sidekiq
    rescue EasyMonitor::Util::Errors::HighLatencyError => e
      sidekiq_high_latency_message(e)
    rescue EasyMonitor::Util::Errors::HighQueueNumberError => e
      sidekiq_high_queue_message(e)
    rescue StandardError
      sidekiq_error_message
    end

    private

    def active_record_alive_message
      render json: {
        message: t('active_record_alive.alive')
      }, status: 200
    end

    def active_record_not_alive_message
      render json: {
        message: t('active_record_alive.not_alive')
      }, status: 503
    end

    def active_record_not_set_up
      render json: {
        message: t('active_record_alive.not_set_up')
      }, status: 503
    end

    def sidekiq_alive_message
      render json: {
        message: t('sidekiq.alive')
      }, status: 200
    end

    # returning a request timeout 504
    def sidekiq_high_latency_message(error)
      log_message(error.message)
      render json: {
        message: error.message
      }, status: :request_timeout
    end

    def sidekiq_high_queue_message(error)
      log_message(error.message)
      render json: {
        message: error.message
      }, status: 200
    end

    # return a 503 status code when not available
    def sidekiq_error_message
      log_message(t('sidekiq.not_set_up'))
      render json: {
        message: t('sidekiq.not_set_up')
      }, status: :service_unavailable
    end

    def active_record_connection
      EasyMonitor.database_alive?
    end

    def connect_to_sidekiq
      EasyMonitor.sidekiq_alive?
    end
  end
end
