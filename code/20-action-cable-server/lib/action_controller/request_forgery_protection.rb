module ActionController
  module RequestForgeryProtection
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def protect_from_forgery(options)
        # Not implemented
      end
    end
  end
end