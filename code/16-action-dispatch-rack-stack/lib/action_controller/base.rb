module ActionController
  class Base < Metal
    include Callbacks
    include RequestForgeryProtection
  end
end