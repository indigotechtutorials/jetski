module Jetski
  module Database
    module Base
      extend self

      def db
        @_db ||= SQLite3::Database.new "test.db"
      end

      def gen_sql(table_name:, field_names:)
        _gen_sql = ""
        _gen_sql += "create table #{table_name} (\n"
        # TODO: add default fields
        _gen_sql += "\n"
        field_names.each.with_index do |field_name, idx|
          _gen_sql += "  #{field_name} varchar(255)"
          if (idx + 1) < field_names.size
            _gen_sql += ",\n"
          else
            _gen_sql += "\n"
          end
        end
        _gen_sql += ");\n"
        _gen_sql
      end
    end
  end
end