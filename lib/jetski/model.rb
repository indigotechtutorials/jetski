module Jetski
  class Model
    extend Jetski::Database::Base

    def initialize(**args)
      @virtual_attributes = {}
      
      args.each do |k, v|
        @virtual_attributes[k] = v
      end
      
      @virtual_attributes["id"]         ||= ""
      @virtual_attributes["created_at"] ||= ""
      @virtual_attributes["updated_at"] ||= ""

      @virtual_attributes.each do |k, v|
        self.class.class_eval do 
          define_method(k) { v }
        end
      end

      self.class.class_eval do 
        define_method(:inspect) do
          post_obj_id = object_id
          inspect_str = "#<Post:#{post_obj_id}"
          @virtual_attributes.each do |k, v|
            inspect_str += " #{k}=\"#{v}\""
          end
          inspect_str += ">"
          inspect_str
        end
      end
    end

    class << self
      def create(**args)
        return puts "#{table_name.capitalize}.create was called with no args" if args.size == 0
        data_values = args.map { |k,v| v }
        key_names = args.map { |k, v| k }
        
        # Set default values on create

        key_names.append "created_at"
        data_values.append Time.now.to_s

        key_names.append "id"
        data_values.append(count + 1)

        sql_command = <<~SQL
          INSERT INTO #{pluralized_table_name} (#{key_names.join(", ")}) 
          VALUES (#{(1..key_names.size).map { |n| "?" }.join(", ")})
        SQL

        db.execute(sql_command, data_values)

        post_attributes = {}
        key_names.each.with_index do |k, i|
          post_attributes[k] = data_values[i]
        end

        new(**post_attributes)
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
        return unless row
        columns ||= attributes
        row_obj = {}
        columns.each.with_index do |col, idx|
          row_obj[col] = row[idx]
        end
        new(**row_obj)
      end
    end
  end
end