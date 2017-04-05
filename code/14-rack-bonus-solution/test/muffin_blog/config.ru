# This file is used by Rack-based servers to start the application.

class MiniSinatra
  class Route < Struct.new(:method, :path, :block)
    def match?(env)
      env["REQUEST_METHOD"] == method && env["PATH_INFO"] == path
    end
  end

  def initialize
    @routes = []
  end

  def add_route(method, path, &block)
    @routes << Route.new(method, path, block)
  end

  def call(env)
    if route = @routes.detect { |route| route.match?(env) }
      body = route.block.call
      [
        200,
        { 'Content-Type' => 'text/plain' },
        [ body ]
      ]
    else
      [
        404,
        { 'Content-Type' => 'text/plain' },
        [ "Not found" ]
      ]
    end
  end

  def self.application
    @application ||= MiniSinatra.new
  end
end

def get(path, &block)
  MiniSinatra.application.add_route "GET", path, &block
end

get "/hello" do
  "hello"
end
get "/goodbye" do
  "goodbye"
end

run MiniSinatra.application