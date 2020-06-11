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
      request_started = client.time_millis
      response = call_app(env)
      if EasyMonitor::Engine.use_influxdb
        client.influxdb_write_actions(
          request, request_started
        )
      end
      response
    end

    private

    def call_app(env)
      @app.call(env)
    rescue Exception => e
      if EasyMonitor::Engine.use_influxdb
        client.influxdb_write_exceptions(
          env, e
        )
      end
      raise e
    end

    def client
      EasyMonitor::Influxdb::Client.new(
        time_precision: 'ms'
      )
    end
  end
end
