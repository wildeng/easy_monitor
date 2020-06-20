# frozen_string_literal: true

require_dependency 'easy_monitor/application_controller'

#:nodoc
module EasyMonitor
  class HealthChecksController < ApplicationController
    protect_from_forgery

    # heartbeat of the application
    def alive
      msg = { message: 'alive'}
      respond_to do |format|
        format.json { render json: msg, status: 200 }
        format.all { head :no_content }
      end
    end

    # TODO: check the openapi specification and take a look if this is compliant
    def sidekiq_alive
      render json: {
        message: 'Sidekiq is alive'
      }, status: 200 if connect_to_sidekiq
    rescue EasyMonitor::Util::Errors::HighLatencyError
      EasyMonitor::Engine.logger.error('Sidekiq is experiencing a high latency')
      render json: {
        message: 'Sidekiq is experiencing a high latency'
      }, status: 200
    rescue EasyMonitor::Util::Errors::HighQueueNumberError
      EasyMonitor::Engine.logger.error('Too many jobs enqueued in Sidekiq')
      render json: {
        message: 'Too many jobs enqueued in Sidekiq'
      }, status: 200
    rescue StandardError
      EasyMonitor::Engine.logger.error('Sidekiq is not responding or not set')
      render json: {
        message:'Sidekiq is not responding or not set'
      }, status: 200
    end

    private

    def connect_to_sidekiq
      EasyMonitor.sidekiq_alive?
    end
  end
end
