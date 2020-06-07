# frozen_string_literal: true

require 'influxdb'

module EasyMonitor
  module Influxdb
    class Client
      attr_reader :client

      def initialize(options = {})
        host = {
          host: EasyMonitor::Engine.influxdb_host.to_s,
          port: EasyMonitor::Engine.influxdb_port.to_s
        }
        @client = InfluxDB::Client.new 'easy_monitor', options.merge(host)
      end

      def write(name, payload, tags = {})
        client.write_point name, data(tags, payload)
      end

      def data(tags, payload)
        {
          tags: tags,
          values: payload
        }
      end
    end
  end
end
