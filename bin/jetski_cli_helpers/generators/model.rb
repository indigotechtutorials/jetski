module JetskiCLIHelpers
  module Generators
    module Model
      def generate_model(name, *field_names)
        db.execute create_table_sql(table_name: name, field_names: field_names)
        model_file_path = "app/models/#{name}.rb"
        create_file model_file_path
        append_to_file model_file_path, <<~MODEL
          class #{name.capitalize} < Jetski::Model
            
          end
        MODEL
      end
    end
  end
end

