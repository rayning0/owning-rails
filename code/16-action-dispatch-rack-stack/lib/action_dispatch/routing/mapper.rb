module ActionDispatch
  module Routing
    class Mapper
      def initialize(route_set)
        @route_set = route_set
      end

      def get(path, to:, as: nil)
        # to => "controller#index"
        controller, action = to.split("#")
        @route_set.add_route("GET", path, controller, action, as)
      end

      def root(to:)
        get "/", to: to, as: 'root'
      end

      def resources(plural_name)
        get "/#{plural_name}", to: "#{plural_name}#index", as: plural_name.to_s
        get "/#{plural_name}/new", to: "#{plural_name}#new",
                                   as: "new_" + plural_name.to_s.singularize
        get "/#{plural_name}/show", to: "#{plural_name}#show",
                                    as: plural_name.to_s.singularize
      end
    end
  end
end