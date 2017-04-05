module ActiveRecord
  class Relation
    def initialize(klass)
      @klass = klass
      @where_values = []
      @order_values = []
    end

    def where!(condition)
      @where_values += [condition]
      self
    end

    def where(condition)
      clone.where!(condition)
    end

    def order!(condition)
      @order_values += [condition]
      self
    end

    def order(condition)
      clone.order!(condition)
    end

    def to_sql
      sql = "SELECT * FROM #{@klass.table_name}"

      if @where_values.any?
        sql += " WHERE " + @where_values.join(" AND ")
      end

      if @order_values.any?
        sql += " ORDER BY " + @order_values.join(", ")
      end

      sql
    end

    def records
      @records ||= @klass.find_by_sql(to_sql)
    end

    def first
      records.first
    end

    def each(&block)
      records.each(&block)
    end
  end
end