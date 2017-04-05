require "test_helper"

class ActionCableTest < Minitest::Test
  def setup
    @server = Thin::Server.new(8082, ActionCable.server)
    Thin::Logging.silent = true

    @thread = Thread.new { @server.start }
    wait_for { @server.running? }

    @websocket = Faye::WebSocket::Client.new("ws://127.0.0.1:8082/")
    wait_for { @websocket.ready_state == Faye::WebSocket::Client::OPEN }
  end

  def test_subscribe
    connection = ActionCable.server.connections.first
    assert connection

    @websocket.send(JSON.dump(command: 'subscribe', channel: 'ChatChannel'))

    wait_for { connection.subscriptions["ChatChannel"] }

    assert ActionCable.server.pubsub.subscribed?("chat")
  end

  def test_message
    @websocket.send(JSON.dump(command: 'subscribe', channel: 'ChatChannel'))

    received = nil
    @websocket.on :message do |event|
      received = JSON.parse(event.data)
    end
    @websocket.send(JSON.dump(command: 'message', channel: 'ChatChannel',
                              data: 'hi!'))

    wait_for { received }
    assert_equal({ 'channel' => 'ChatChannel', 'message' => 'hi!' }, received)
  end

  def teardown
    @server.stop!
    @thread.join
  end

  def wait_for
    Timeout.timeout 3 do
      Thread.pass until yield
    end
  end
end