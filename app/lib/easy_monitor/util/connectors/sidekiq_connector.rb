# frozen_string_literal: true

# class that does some checks on Sidekiq
# and returns a boolean value to check its availability
#:nodoc: all
module EasyMonitor
  module Util
    module Connectors
      require 'singleton'
      require 'redis'
      require 'sidekiq/api'

      class SidekiqConnector
        include Singleton

        # Returns true if alive otherwise raises an error
        #
        # @return [boolean] true if Sidekiq checks are fine
        def alive?
          raise StandardError unless EasyMonitor::Engine.use_sidekiq

          latency_checks
          queue_checks
          processes_checks
          true
        end

        def latency
          @latency = Sidekiq::Queue.new.latency
        end

        def stats
          @stats = Sidekiq::Stats.new
        end

        def latency_checks
          return unless high_latency?

          raise EasyMonitor::Util::Errors::HighLatencyError.new(
            I18n.t('sidekiq.high_latency'), SidekiqConnector.class.name
          )
        end

        def queue_checks
          return unless high_queue_number?

          raise EasyMonitor::Util::Errors::HighQueueNumberError.new(
            I18n.t('sidekiq.high_queue'), SidekiqConnector.class.name
          )
        end

        def processes_checks
          return if processing?

          raise EasyMonitor::Util::Errors::NotWorking.new(
            I18n.t('sidekiq.error'), SidekiqConnector.class.name
          )
        end

        def high_latency?
          latency > EasyMonitor::Engine.max_latency
        end

        def high_queue_number?
          stats.enqueued > EasyMonitor::Engine.max_queue_number
        end

        def processing?
          stats.processes_size.positive?
        end
      end
    end
  end
end
