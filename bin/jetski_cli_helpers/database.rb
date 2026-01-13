module JetskiCLIHelpers
  class Database < Base
    desc "create", "Creates a database for your app"
    def create
      say "🌊 Database was created successfully!"
    end

    desc "create_table NAME COLUMN_NAMES", "Creates a new table in your database"
    def create_table(name, *fields)
      db.execute create_table_sql(table_name: name, field_names: fields)
    end

    desc "seed", "Seeds the database with records created from seed file"
    def seed
      seed_file_path = './seed.rb'
      if File.exist?(seed_file_path)
        Jetski::Autoloader.call
        load(seed_file_path)
      else
        say "No seed file is specified create one in your app ./seed.rb"
      end
    end
  end
end