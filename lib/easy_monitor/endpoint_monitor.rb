# frozen_string_literal: true

module EasyMonitor
  class EndpointMonitor
    def initialize(app)
      @app = app
    end

    def call(env)
      request = Rack::Request.new(env)
      response = call_app(env)
      byebug
      response
    end

    private

    def call_app(env)
      @app.call(env)
    end
  end
end
