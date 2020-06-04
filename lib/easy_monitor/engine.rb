# frozen_string_literal: true

require 'easy_monitor/log/easy_monitor_logger'
require 'easy_monitor/middleware'

module EasyMonitor
  class Engine < ::Rails::Engine
    config.app_middleware.insert_after ActionDispatch::DebugExceptions, EasyMonitor::Middleware

    isolate_namespace EasyMonitor

    DEFAULT_SIDEKIQ_PROCESS_NUMBERS = 1
    DEFAULT_SIDEKIQ_JOB_THRESHOLD = 50
    DEFAULT_REDIS_URL = '127.0.0.1'
    DEFAULT_REDIS_PORT = 6379
    DEFAULT_MAX_QUEUE_NUMBER = 250
    DEFAULT_MAX_LATENCY = 600
    DEFAULT_LOG_PATH = STDOUT
    DEFAULT_INFLUXDB_HOST = 'localhost'
    DEFAULT_INFLUXDB_PORT = '8086'

    class << self
      mattr_accessor :redis_url
      mattr_accessor :redis_port
      mattr_accessor :user_class
      mattr_accessor :sidekiq_process_numbers
      mattr_accessor :sidekiq_job_threshold
      mattr_accessor :use_sidekiq
      mattr_accessor :max_latency
      mattr_accessor :max_queue_number
      mattr_accessor :log_path
      mattr_accessor :use_totp
      mattr_accessor :totp_secret
      mattr_accessor :use_memcached
      mattr_accessor :cache
      mattr_accessor :influxdb_host
      mattr_accessor :influxdb_port

      self.redis_url = DEFAULT_REDIS_URL
      self.redis_port = DEFAULT_REDIS_PORT
      self.sidekiq_process_numbers = DEFAULT_SIDEKIQ_PROCESS_NUMBERS
      self.sidekiq_job_threshold = DEFAULT_SIDEKIQ_JOB_THRESHOLD
      self.use_sidekiq = false
      self.max_latency = DEFAULT_MAX_LATENCY
      self.max_queue_number = DEFAULT_MAX_QUEUE_NUMBER
      self.log_path = DEFAULT_LOG_PATH
      self.use_memcached = false
      self.cache = nil
      self.use_totp = false
      self.totp_secret = nil
      self.influxdb_host = DEFAULT_INFLUXDB_HOST
      self.influxdb_port = DEFAULT_INFLUXDB_PORT
    end

    def self.setup
      yield self
    end

    def logger
      EasyMonitor::Log::EasyMonitorLogger.new(
        EasyMonitor::Engine.log_path
      )
    end

    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_bot # newly added code
      g.factory_bot dir: 'spec/factories' # newly added code
    end
  end
end
