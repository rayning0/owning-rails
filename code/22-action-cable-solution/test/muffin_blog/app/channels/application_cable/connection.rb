module ApplicationCable
  class Connection < ActionCable::Connection::Base
    def connect
      if request.params["token"] != "valid"
        close
      end
    end
  end
end
