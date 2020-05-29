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
      request_started = Time.now
      status, headers, body = @app.call(env)
      # TODO: need to check the response
      # response = Rack::Response.new(body, status, headers)
      request_ended = Time.now
      delta = request_started - request_ended
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

    def request_object(request, start, delta)
      {
        timestamp: Time.now,
        req_method: request.method,
        req_path: request.path_info,
        req_server: request.server,
        req_port: request.server_porth,
        req_start: start,
        req_delta: delta
      }
    end

    def response_object(body, status, headers)
      r = Rack::Response.new(body, status, headers)
      r.inspect
      # TODO: take some interesting parts out of this
    end

    def exception_object(exception)
      {
        timestamp: Time.now,
        exception: exception
      }
    end
  end
end
