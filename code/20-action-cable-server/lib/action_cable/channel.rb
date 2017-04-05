module ActionCable
  module Channel
    class Base
      def initialize(server, connection)
        @server = server
        @connection = connection
      end

      def perform_action(data)
        action = data['action'] || 'receive'
        send action, data['data']
      end

      def stream_from(name)
        @server.pubsub.subscribe name do |message|
          @connection.transmit channel: self.class.name, message: message
        end
      end
    end
  end
end