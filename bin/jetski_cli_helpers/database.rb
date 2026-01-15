module JetskiCLIHelpers
  class Database < Base
    desc "migrate", "Create, load, and patch DB from models"
    def migrate
      Jetski::Autoloader.call
      # Get all models defined in users app
      Jetski::Model.subclasses.each do |model|
        table_name = model.pluralized_table_name
        # Create table if it doesnt exist
        create_table(table_name) if !table_exists?(table_name)
        # Get model attributes
        model.db_attribute_values.each do |obj|
          name = obj[:name]
          type = obj[:type]
          add_column_unless_exists(table_name, name, type)
        end
      end
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