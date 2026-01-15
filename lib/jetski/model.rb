class Jetski
  class Model
    extend Jetski::Database::Base, Jetski::Helpers::Generic, 
      Jetski::Model::Attributes
    include CrudHelpers, Jetski::Helpers::Generic

    def initialize(**args)
      @virtual_attributes = args
    end

    def inspect
      inspect_str = "#<#{self.class.to_s}:#{object_id}"
      self.class.attribute_names.each do |attribute_name|
        attribute_value = @virtual_attributes[attribute_name]
        inspect_str += " #{attribute_name}=\"#{attribute_value}\""
      end
      inspect_str += ">"
      inspect_str
    end

    class << self
      extend Jetski::Helpers::Delegatable
      delegate :count, :last, :first, to: :all

      def table_name
        self.to_s.downcase
      end

      def pluralized_table_name
        pluralize_string(table_name)
      end
      
      # Mark attributes method as private hide it from IRB
      private :attributes
    private
      def format_model_obj(row, columns)
        row_obj = {}
        columns.each.with_index do |col, idx|
          row_obj[col.to_sym] = row[idx]
        end
        new(**row_obj)
      end
    end
  end
end