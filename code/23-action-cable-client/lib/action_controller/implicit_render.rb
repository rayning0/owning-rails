module ActionController
  module ImplicitRender
    def process(action)
      super
      render action if response.empty?
    end
  end
end