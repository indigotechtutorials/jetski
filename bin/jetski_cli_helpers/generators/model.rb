module JetskiCLIHelpers
  module Generators
    module Model
      def generate_model(name, *field_names)
        # TODO: Instead of creating table here we should have a db:migrate method
        # this will automatically build and patch db tables. Add/remove columns 
        #db.execute create_table_sql(table_name: name, field_names: field_names)
        @model_name = name
        @field_names = field_names.map { |f| f.split(":")[0] }
        model_file_path = "app/models/#{name}.rb"
        template "model/template.rb.erb", model_file_path
      end
    end
  end
end

