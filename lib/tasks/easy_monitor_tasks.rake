# frozen_string_literal: true

# desc "Explaining what the task does"
# task :easy_monitor do
#   # Task goes here
# end

# Create an influxdb db
namespace :easy_monitor do
  desc 'Create a influx db called easy_monitor default to localhost port 8086'\
    'you can pass tour host and port to the task <host> <port>'
  task :easydb, [:host, :port] do |_t, args|
    host = args[:host] || 'localhost'
    port = args[:port] || '8086'
    command = "http://#{host}:#{port}/query --data-urlencode \"q=CREATE DATABASE easy_monitor\""
    `curl -G #{command}`
  end
end
