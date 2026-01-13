class Jetski
  class Model
    extend Jetski::Database::Base, Jetski::Helpers::Generic
    include CrudHelpers, Jetski::Helpers::Generic

    def initialize(**args)
      @virtual_attributes = args
    end

    def inspect
      post_obj_id = object_id
      inspect_str = "#<#{self.class.to_s}:#{post_obj_id}"
      self.class.attribute_names.each do |attribute_name|
        attribute_value = @virtual_attributes[attribute_name]
        inspect_str += " #{attribute_name}=\"#{attribute_value}\""
      end
      inspect_str += ">"
      inspect_str
    end

    class << self
      def attributes(*attribute_names)
        @_attribute_names ||= []
        @_attribute_names.concat([:created_at, :updated_at, :id]) # defaults
        @_attribute_names.concat(attribute_names)
        @_attribute_names = @_attribute_names.uniq
        attribute_names.each do |attribute|
          define_method attribute do
            @virtual_attributes[attribute]
          end
        end
      end

      def attribute_names
        @_attribute_names || []
      end

      def pluck_rows
        db.execute( "select * from #{pluralized_table_name}" )
      end

      def count
        pluck_rows.size
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
        pluralize_string(table_name)
      end
    private
      def format_model_obj(row, columns = nil)
        return unless row
        columns ||= attribute_names
        row_obj = {}
        columns.each.with_index do |col, idx|
          row_obj[col] = row[idx]
        end
        new(**row_obj)
      end
    end
  end
end