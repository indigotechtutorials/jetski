module Jetski
  class Model
    extend Jetski::Database::Base

    def initialize(**args)
      # TODO: Need to fix code
      # Cannot redefine methods every time we initialize a new object.
      # need to define available methods on post when loading model
      @virtual_attributes = args
    end

    def inspect
      post_obj_id = object_id
      inspect_str = "#<Post:#{post_obj_id}"
      self.class.model_attributes.each do |attribute_name|
        attribute_value = @virtual_attributes[attribute_name]
        inspect_str += " #{attribute_name}=\"#{attribute_value}\""
      end
      inspect_str += ">"
      inspect_str
    end

    def destroy!
      # Destroy record: remove from db
      delete_sql = <<~SQL
        DELETE from #{self.class.pluralized_table_name} WHERE id=?
      SQL
      self.class.db.execute(delete_sql, id)
      nil
    end

    class << self
      def create(**args)
        return puts "#{table_name.capitalize}.create was called with no args" if args.size == 0
        data_values = args.map { |k,v| v }
        key_names = args.map { |k, v| k }
        
        # Set default values on create

        key_names.append "created_at"
        data_values.append Time.now.to_s

        current_post_count = (count || 0)
        post_id = current_post_count + 1
        key_names.append "id"
        data_values.append(post_id)

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

      # Careful methods / delete all records from table
      def destroy_all! 
        db.execute("DELETE from #{pluralized_table_name}")
      end

      def define_attribute_methods
        model_attributes.each do |attribute|
          define_method attribute do
            @virtual_attributes[attribute]
          end
        end
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
      
      def model_attributes
        attributes.concat(["id", "created_at", "updated_at"])
      end

    private
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