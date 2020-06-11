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

      def influxdb_write_actions(request, start)
        delta = time_millis - start
        write(
          'easy_monitor_middleware',
          request_object(request, start, delta),
          { type: 'process_actions' }
        )
      end

      def influxdb_write_exceptions(env, exception)
        exp = env['action_dispatch.exception'] unless exception
        exp = "#{exception.message} #{exception.backtrace.join('\n')}" if exception
        write(
          'easy_monitor_middleware',
          exception_object(exp),
          { type: 'app_exceptions' }
        )
      end

      def time_millis
        Time.now.to_i * 1000
      end

      def request_object(request, start, delta)
        {
          value: time_millis,
          req_method: request.request_method,
          req_path: request.path_info,
          req_server: request.server_name,
          req_port: request.server_port,
          req_start: start,
          req_duration: delta
        }
      end

      def response_object(body, status, headers)
        r = Rack::Response.new(body, status, headers)
        r.inspect
        # TODO: take some interesting parts out of this
      end

      def exception_object(exception)
        {
          value: time_millis,
          exception: exception
        }
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
