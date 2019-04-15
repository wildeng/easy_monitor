module EasyMonitor
  class Engine < ::Rails::Engine
    isolate_namespace EasyMonitor

    class << self
      mattr_accessor :redis_url
      mattr_accessor :redis_port
      mattr_accessor :user_class

      self.redis_url = '127.0.0.1'
      self.redis_port = 6379
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
