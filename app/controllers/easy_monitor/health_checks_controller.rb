require_dependency 'easy_monitor/application_controller'

module EasyMonitor
  class HealthChecksController < ApplicationController
    protect_from_forgery

    before_action :basic_authentication
    
    def alive
      head :no_content
    end

    def redis_alice
    end

    def sidekiq_alive
    end

    private

    def basic_authentication
      # TODO: implements a basic authentication related to the calling app 
      return true
    end
  end
end
