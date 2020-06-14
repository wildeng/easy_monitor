# frozen_string_literal: true

require_dependency 'easy_monitor/application_controller'

#:nodoc
module EasyMonitor
  class HealthChecksController < ApplicationController
    protect_from_forgery

    # heartbeat of the application
    def alive
      msg = { status: 200, message: 'alive'}
      respond_to do |format|
        format.json { render json: msg }
        format.all { head :no_content }
      end
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

    def connect_to_sidekiq
      EasyMonitor.sidekiq_alive?
    end
  end
end
