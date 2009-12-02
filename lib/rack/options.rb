module Rack

class Options
  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)
    if options?(env)
      headers["Content-Length"] = '0'
      [status, headers, []]
    else
      [status, headers, body]
    end
  end

  def options?(env)
    env["REQUEST_METHOD"] == "OPTIONS"
  end
end

end
