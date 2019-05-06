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
          raise HighLatencyError if high_latency?
          raise HighQueueNumberError if high_queue_number?
          raise StandarError unless processing?
          true
        end

        private

        def latency
          @latency = Sidekiq::Queue.new.latency
        end

        def stats
          @stats = Sidekiq::Stats.new
        end

        def high_latency?
          latency > EasyMonitor::Engine.max_latency
        end

        def high_queue_number?
          stats.enqueued > EasyMonitor::Engine.max_queue_number
        end

        def processing?
          stats.processes_size > 0
        end
      end
    end
  end
end
