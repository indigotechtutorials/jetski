require 'thor'
module JetskiCLIHelpers
  class Database < Thor
    include Thor::Actions, JetskiCLIHelpers::SharedMethods,
      Jetski::Database::Base
    desc "create", "Creates a database for your app"
    def create
      say "🌊 Database was created successfully!"
    end

    desc "create_table NAME COLUMN_NAMES", "Creates a new table in your database"
    def create_table(name, *fields)
      db.execute create_table_sql(table_name: name, field_names: fields)
    end
  end
end