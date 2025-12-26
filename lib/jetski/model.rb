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
        columns, *rows = db.execute2( "select * from #{pluralized_table_name}" )
        _all = []
        rows.map do |row|
          _all << format_model_obj(row, columns)
        end
        _all
      end

      def pluck_rows
        db.execute( "select * from #{pluralized_table_name}" )
      end

      def count
        pluck_rows.size
      end

      def attributes
        columns, *rows = db.execute2( "select * from #{pluralized_table_name}" )
        columns
      end

      def last
        format_model_obj(pluck_rows.last)
      end

      def first
        format_model_obj(pluck_rows.first)
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

      def format_model_obj(row, columns = nil)
        columns ||= attributes
        row_obj = {}
        columns.each.with_index do |col, idx|
          row_obj[col] = row[idx]
        end
        OpenStruct.new(row_obj)
      end
    end
  end
end