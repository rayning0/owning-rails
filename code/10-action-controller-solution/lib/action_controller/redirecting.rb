module ActionController
  module Redirecting
    def redirect_to(location)
      response.status = 302
      response.location = location
      response.body = ["You are being redirected"]
    end
  end
end