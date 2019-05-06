module EasyMonitor
  class Engine < ::Rails::Engine
    isolate_namespace EasyMonitor
    # TODO: move all constants in a constants file
    DEFAULT_SIDEKIQ_PROCESS_NUMBERS = 1
    DEFAULT_SIDEKIQ_JOB_THRESHOLD = 50
    DEFAULT_REDIS_URL = '127.0.0.1'.freeze
    DEFAULT_REDIS_PORT = 6379
    DEFAULT_MAX_QUEUE_NUMBER = 250
    DEFAULT_MAX_LATENCY = 600
    DEFAULT_LOG_PATH = 'log/easy_monitor.log'


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

      self.redis_url = DEFAULT_REDIS_URL
      self.redis_port = DEFAULT_REDIS_PORT
      self.sidekiq_process_numbers = DEFAULT_SIDEKIQ_PROCESS_NUMBERS
      self.sidekiq_job_threshold = DEFAULT_SIDEKIQ_JOB_THRESHOLD
      self.use_sidekiq = false
      self.max_latency = DEFAULT_MAX_LATENCY
      self.max_queue_number = DEFAULT_MAX_QUEUE_NUMBER
      self.log_path = DEFAULT_LOG_PATH
    end

    def self.setup
      yield self
    end

    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_bot # newly added code
      g.factory_bot dir: 'spec/factories' # newly added code
    end
  end
end
