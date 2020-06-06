# frozen_string_literal: true

require 'easy_monitor/engine'
require 'influxdb'

module EasyMonitor
  class << self
    def redis_ping
      EasyMonitor::Util::Connectors::RedisConnector.instance.ping
    end

    def sidekiq_alive?
      EasyMonitor::Util::Connectors::SidekiqConnector.instance.alive?
    end

    def sidekiq_check; end

    def sidekiq_active_jobs; end

    def sidekiq_all_queues; end
  end
end
