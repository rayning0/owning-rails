module ActionController
  class Metal
    attr_accessor :request, :response

    def process(action)
      send action
    end

    def params
      request.params.symbolize_keys
    end
  end
end