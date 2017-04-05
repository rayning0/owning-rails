# This file is used by Rack-based servers to start the application.

class App
  def call(env)
    if env["REQUEST_METHOD"] == "GET" && env["PATH_INFO"] == "/hello"
      [
        200,
        { 'Content-Type' => 'text/plain' },
        [ "hello" ]
      ]
    else
      [
        404,
        { 'Content-Type' => 'text/plain' },
        [ "Not found" ]
      ]
    end
  end
end

class Logger
  def initialize(app)
    @app = app
  end

  def call(env)
    method = env["REQUEST_METHOD"]
    path = env["PATH_INFO"]
    puts "#{method} #{path}"
    @app.call(env)
  end
end

use Logger
run App.new
