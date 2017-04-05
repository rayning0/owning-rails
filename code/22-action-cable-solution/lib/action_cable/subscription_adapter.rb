module ActionCable
  module SubscriptionAdapter
    class Inline
      def initialize
        @subscriptions = Hash.new { |h,k| h[k] = [] }
      end

      def subscribe(name, &block)
        @subscriptions[name] << block
      end

      def subscribed?(name)
        @subscriptions.key? name
      end

      def broadcast(name, message)
        @subscriptions[name].each do |block|
          block.call(message)
        end
      end
    end

    # Other adapters: Redis, Postgres NOTIFY
  end
end