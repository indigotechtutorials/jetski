module Jetski
  module Database
    module Base
      extend self

      def db
        @_db ||= SQLite3::Database.new "test.db"
      end

      def create_table_sql(table_name:, field_names:)
        pluralized_table_name = if table_name.chars.last == "s"
          table_name
        else
          table_name + "s"
        end

        _gen_sql = ""
        _gen_sql += "create table #{pluralized_table_name} (\n"
        
        # Default fields on all models
        _gen_sql += "  created_at datetime,\n"
        _gen_sql += "  updated_at datetime,\n"
        _gen_sql += "  id integer,\n"

        field_names.each.with_index do |field_name, idx|
          field, field_data_type = if field_name.include?(":")
            field_name.split(":")
          else
            [field_name, ""]
          end
          data_type = sql_data_type(field_data_type)
          _gen_sql += "  #{field} #{data_type}"
          if (idx + 1) < field_names.size
            _gen_sql += ",\n"
          else
            _gen_sql += "\n"
          end
        end
        _gen_sql += ");\n"
        _gen_sql
      end

      def sql_data_type(str)
        case str
        when "", "string"
          "varchar(255)"
        else
          str
        end
      end
    end
  end
end