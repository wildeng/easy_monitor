require_dependency "easy_monitor/application_controller"

module EasyMonitor
  class HealthChecksController < ApplicationController
    def alive
      head :no_content
    end
  end
end
