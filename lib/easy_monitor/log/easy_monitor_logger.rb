# frozen_string_literal: true

require 'easy_monitor/log/log_formatter'

module EasyMonitor
  module Log
    class EasyMonitorLogger < ActiveSupport::Logger
      # Engine logger with custom formatter
      def initialize(*args)
        super(*args)
        @formatter = EasyMonitor::Log::LogFormatter.new
      end
    end
  end
end
