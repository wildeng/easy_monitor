# class that does some checks on Sidekiq
# and returns a boolean value to check its availability
#:nodoc: all
module EasyMonitor
  module Util
    module Connectors
      require 'singleton'
      require 'redis'

      class SidekiqConnector
        include Singleton

        def alive?
          return false if high_latency?
          return false if high_queue_number?

          is_processing?
        end

        private

        def latency
          @latency = Sidekiq::Queue.new.latency
        end

        def stats
          @stats = Sidekiq::Stats.new
        end

        def high_latency?
          latency > 600
        end

        def high_queue_number?
          stats.enqueued > 250
        end

        def processing?
          stats.processes_size > 0
        end
      end
    end
  end
end
