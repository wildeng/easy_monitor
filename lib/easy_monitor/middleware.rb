# frozen_string_literal: true

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
      status, headers, body = @app.call(env)
      # TODO: need to check the response
      # response = Rack::Response.new(body, status, headers)
      delta = time_millis - request_started

      # TODO: refactor this part moving the code in its own class
      data = data(
        {'type': 'process_actions'},
        request_object(request, request_started, delta)
      )
      client.write_point('easy_monitor_middleware',data)

      # TODO: this needs to be put in its class
      Rails.logger.debug " This is my exception: #{env['action_dispatch.exception']}"
      #Rails.logger.debug response_object(body, status, headers)
      #Rails.logger.debug debug_string(request, request_started, delta, status)
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

    def time_millis
      (Time.now.to_r * 1000).to_i
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
        hook: 'runtime_exceptions',
        exception: exception
      }
    end

    def data(tags, payload)
      {
        values: payload,
        tags: tags
      }
    end

    # TODO: move the client in it's own library and use username and password
    def client
      database = 'easy_monitor'
      InfluxDB::Client.new database, time_precision: 'ms' # defaults to localhost:8086
    end
  end
end
