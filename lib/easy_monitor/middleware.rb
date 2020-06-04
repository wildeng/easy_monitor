# frozen_string_literal: true

require 'easy_monitor/influxdb/client'

module EasyMonitor
  class Middleware
    def initialize(app)
      @app = app
    end

    # Just started experimenting with the metrics
    # The middleware should collect all the necessary metrics and save them
    # Persistence mechanism has not been chosen yet

    def call(env)
      request = Rack::Request.new(env)
      request_started = time_millis
      begin
        status, headers, body = @app.call(env)
      rescue Exception => ex
        Rails.logger.error "This is my exception: #{env['action_dispatch.exception']}"
        influxdb_write_exceptions(env['action_dispatch.exception'])
        raise ex
      end
      delta = time_millis - request_started
      influxdb_write_actions(request, request_started, delta)
      [status, headers, body]
    end

    private

    def timestamp
      Time.now.strftime("%Y-%M-%d %H:%m:%S")
    end

    def debug_string(request, start, delta, status)
      debug_string = <<-LOG
        #{timestamp}
        Request PATH: #{request.path_info},
        Request METHOD: #{request.request_method},
        Request PORT: #{request.server_port},
        Params: #{request.params}
        SERVER: #{request.server_name},
        Request Delta Time: #{delta} seconds
        Response Status: #{status}
      LOG
    end

    private

    def influxdb_write_actions(request, start, delta)
      client.write(
        'easy_monitor_middleware',
        request_object(request, start, delta),
        { type: 'process_actions'}
      )
    end

    def influxdb_write_exceptions(exception)
      client.write(
        'easy_monitor_middleware',
        exception_object(exception),
        { type: 'app_exceptions'}
      )
    end

    def client
      EasyMonitor::Influxdb::Client.new(
        time_precision: "ms"
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
  end
end
