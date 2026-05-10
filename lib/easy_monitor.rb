# frozen_string_literal: true

require 'easy_monitor/engine'
require 'influxdb'

module EasyMonitor
  class << self
    def database_alive?
      EasyMonitor::Util::Connectors::ActiverecordConnector.new.database_alive?
    end

    def redis_ping
      EasyMonitor::Util::Connectors::RedisConnector.instance.ping
    end

    def sidekiq_alive?
      EasyMonitor::Util::Connectors::SidekiqConnector.instance.alive?
    end
  end
end
