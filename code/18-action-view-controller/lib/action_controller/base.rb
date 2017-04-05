module ActionController
  class Base < Metal
    include Callbacks
    include RequestForgeryProtection
    include ActionView::Rendering
  end
end