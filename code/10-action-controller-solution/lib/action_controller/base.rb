module ActionController
  class Base < Metal
    include Callbacks
    include RequestForgeryProtection
    include Redirecting
  end
end