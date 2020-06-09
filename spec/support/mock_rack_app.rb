class MockRackApp
  attr_reader :request_body

  def initialize
    @request_headers = {}
  end

  def call(env)
    @env = env
    handle_request(env['REQUEST_METHOD'], env['PATH_INFO'])
  end

  def env
    @env
  end

  def [](key)
    @env[key]
  end

  def []=(key, value)
    @env[key] = value
  end

  private

  def handle_request(method, path)
    if %w[GET POST PUT PATCH DELETE].include?(method)
      response(method, path)
    else
      [405, {}, "Method not allowed #{method}"]
    end
  end

  def response(method, path)
    if path.include?('error')
      raise StandardError.new("This is an error")
    else
      [
        200,
        { 'Content-Type' => 'text/plain'},
        "You requested this method: #{method}"
      ]
    end
  end
end
