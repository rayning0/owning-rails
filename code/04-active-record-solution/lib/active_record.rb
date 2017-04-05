require "active_record/connection_adapter"

module ActiveRecord
  class Base
    def initialize(attributes = {})
      @attributes = attributes
    end

    def id
      @attributes[:id]
    end

    def title
      @attributes[:title]
    end

    def self.abstract_class=(value)
      # Not implemented
    end

    def self.find(id)
      attributes =
        connection.execute("SELECT * FROM posts WHERE id = #{id.to_i}").first
      new(attributes)
    end

    def self.all
      connection.execute("SELECT * FROM posts").map do |attributes|
        new(attributes)
      end
    end

    def self.establish_connection(options)
      @@connection = ConnectionAdapter::SqliteAdapter.new(options[:database])
    end

    def self.connection
      @@connection
    end
  end
end