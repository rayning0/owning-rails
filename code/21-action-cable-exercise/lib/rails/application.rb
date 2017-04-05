require "sprockets"

module Rails
  class Application
    def self.inherited(klass)
      super
      @instance = klass.new
    end

    def self.instance
      @instance
    end

    def routes
      @routes ||= ActionDispatch::Routing::RouteSet.new
    end

    def initialize!
      config_environment_path = caller.first
      @root = Pathname.new(File.expand_path("../..", config_environment_path))

      ActiveSupport::Dependencies.autoload_paths = Dir["#{@root}/app/*"]

      ActiveRecord::Base.establish_connection(
        database: "#{@root}/db/#{Rails.env}.sqlite3")

      load @root.join("config/routes.rb")
    end

    def root
      @root
    end

    def default_middleware_stack
      Rack::Builder.new do
        use Rack::ContentLength
        use Rack::CommonLogger
        use Rack::ShowExceptions

        use Rack::Static, urls: ["/favicon.ico", "/robots.txt"],
                          root: Rails.root.join("public")

        map "/assets" do
          sprockets = Sprockets::Environment.new
          sprockets.append_path Rails.root.join("app/assets/javascripts")
          sprockets.append_path Rails.root.join("app/assets/stylesheets")

          Dir["#{__dir__}/../*/assets"].each do |path|
            sprockets.append_path path
          end

          run sprockets
        end

        map "/cable" do
          run ActionCable.server
        end
      end
    end

    def app
      @app ||= begin
        stack = default_middleware_stack
        stack.run routes
        stack.to_app
      end
    end

    def call(env)
      app.call(env)
    end
  end
end