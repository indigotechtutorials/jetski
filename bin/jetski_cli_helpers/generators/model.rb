module JetskiCLIHelpers
  module Generators
    module Model
      def generate_model(name, *field_names)
        # TODO: Instead of creating table here we should have a db:migrate method
        # this will automatically build and patch db tables. Add/remove columns 
        #db.execute create_table_sql(table_name: name, field_names: field_names)
        model_file_path = "app/models/#{name}.rb"
        create_file model_file_path
        action_content = if field_names.any?
          "attributes #{field_names.map { |f| ":#{f.split(":")[0]}" }.join(", ") }"
        else
          ""
        end
        model_content = <<~MODEL
          class #{name.capitalize} < Jetski::Model
            #{action_content}
          end
        MODEL
        append_to_file model_file_path, model_content
      end
    end
  end
end

