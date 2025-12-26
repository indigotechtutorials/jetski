module Jetski
  class Model
    extend Jetski::Database::Base
    class << self
      def create(**args)
        return puts "#{table_name.capitalize}.create was called with no args" if args.size == 0
        data_values = args.map { |k,v| v }
        key_names = args.map { |k, v| k }

        sql_command = <<~SQL
          INSERT INTO #{pluralized_table_name} (#{key_names.join(", ")}) VALUES (#{(1..key_names.size).map { |n| "?" }.join(", ")})
        SQL

        db.execute(sql_command, data_values)
      end

      def all
        db.execute( "select * from #{pluralized_table_name}" )
      end

      def count
        all.size
      end

      def attributes
        columns, *rows = db.execute2( "select * from #{pluralized_table_name}" )
        columns
      end
    private
      def table_name
        self.to_s.downcase
      end

      def pluralized_table_name
        if table_name[-1] == "s"
          table_name
        else
          table_name + "s"
        end
      end
    end
  end
end