require 'easy_monitor/engine'

module EasyMonitor
  class << self
    def redis_ping
      EasyMonitor::Util::Connectors::RedisConnector.instance.ping
    end

    def sidekiq_connect
    end

    def sidekiq_check
    end

    def sidekiq_active_jobs
    end

    def sidekiq_all_queues
    end
  end
end
