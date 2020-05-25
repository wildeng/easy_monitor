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
      debug_string = <<-LOG
      Request PATH: #{request.path_info},
      Request METHOD: #{request.request_method},
      Request PORT: #{request.server_port},
      Params: #{request.params}
      SERVER: #{request.server_name},
      Request Delta Time: #{request_ended - request_started} seconds
      Response Status: #{status}
      LOG

      Rails.logger.debug debug_string
      [status, headers, body]
    end
  end
end
