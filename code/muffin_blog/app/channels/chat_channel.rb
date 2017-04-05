# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from "chat"
  end

  def receive(data)
    ActionCable.server.broadcast("chat", data)
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
