require "test_helper"

class ActionDispatchTest < Minitest::Test
  def test_add_route
    routes = ActionDispatch::Routing::RouteSet.new
    route = routes.add_route "GET", "/posts", "posts", "index"

    assert_equal "posts", route.controller
    assert_equal "index", route.action
  end

  def test_find_route
    routes = ActionDispatch::Routing::RouteSet.new
    route = routes.add_route "GET", "/posts", "posts", "index"
    route = routes.add_route "POST", "/posts", "posts", "create"

    request = Rack::Request.new(
      "REQUEST_METHOD" => "POST",
      "PATH_INFO" => "/posts"
    )
    route = routes.find_route(request)

    assert_equal "posts", route.controller
    assert_equal "create", route.action
  end

  def test_draw
    routes = ActionDispatch::Routing::RouteSet.new
    routes.draw do
      get "/hello", to: "hello#index"
      root to: "posts#index"
      resources :posts
    end

    request = Rack::Request.new(
      "REQUEST_METHOD" => "GET",
      "PATH_INFO" => "/posts/new"
    )
    route = routes.find_route(request)

    assert_equal "posts", route.controller
    assert_equal "new", route.action
    assert_equal "new_post", route.name # new_post_path helper
  end

  def test_call
    routes = Rails.application.routes

    request = Rack::MockRequest.new(routes)

    assert request.get("/").ok?
    assert request.get("/posts").ok?
    assert request.get("/posts/new").ok?
    assert request.get("/posts/show?id=1").ok?

    assert request.post("/").not_found?
  end

  def test_middleware_stack
    app = Rails.application

    request = Rack::MockRequest.new(app)

    assert request.get("/").ok?
    assert request.get("/posts").ok?
    assert request.get("/posts/new").ok?
    assert request.get("/posts/show?id=1").ok?

    assert request.post("/").not_found?

    assert request.get("/favicon.ico").ok?
    assert request.get("/assets/application.js").ok?
    assert request.get("/assets/application.css").ok?
  end
end