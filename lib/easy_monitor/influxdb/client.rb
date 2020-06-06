require 'influxdb'

module EasyMonitor
  module Influxdb
    class Client
      def initialize(options = {})
        host = {
          host: "#{EasyMonitor::Engine.influxdb_host}",
          port: "#{EasyMonitor::Engine.influxdb_port}"
        }
        puts host
        @client = InfluxDB::Client.new 'easy_monitor', options.merge(host)
      end

      def write(name, payload, tags = {})
        Rails.logger.info "tags: #{tags.inspect}"
        data = {
          tags: tags,
          values: payload
        }

        client.write_point name, data
      end

      def client
        @client
      end
    end
  end
end
