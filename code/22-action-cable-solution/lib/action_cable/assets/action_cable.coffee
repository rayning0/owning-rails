@ActionCable =
  createConsumer: ->
    new ActionCable.Consumer("ws://localhost:3000/cable")

class ActionCable.Consumer
  constructor: (@url) ->
    @websocket = new WebSocket(@url)
    @subscriptions = []
    @sendQueue = []
  
    @subscriptions.create = (channel, callbacks) =>
      subscription = new ActionCable.Subscription(this, channel, callbacks)
      @subscriptions.push(subscription)
      subscription

    @websocket.onopen = (event) =>
      @send(message) while message = @sendQueue.shift()

    @websocket.onmessage = (event) =>
      data = JSON.parse(event.data)
      @subscriptions.forEach (subscription) ->
        if subscription.channel == data.channel
          subscription.callbacks.received(data.message)

  send: (data) ->
    if @websocket.readyState is WebSocket.OPEN
      @websocket.send(JSON.stringify(data))
    else
      @sendQueue.push(data)

class ActionCable.Subscription
  constructor: (@consumer, @channel, @callbacks) ->
    @consumer.send
      channel: @channel
      command: 'subscribe'

  send: (data) ->
    @consumer.send
      channel: @channel
      command: 'message'
      data: data
