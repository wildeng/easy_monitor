require 'mock_redis'
# Using an empty config file in the dummy app
# forces the engine to use its default values
EasyMonitor::Engine.setup do |config|
end
