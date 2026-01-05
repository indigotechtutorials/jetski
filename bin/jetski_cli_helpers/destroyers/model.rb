module JetskiCLIHelpers
  module Destroyers
    module Model
      def destroy_model(name)
        model_file_path = "app/models/#{name}.rb"
        remove_file(model_file_path)
        # TODO: Move pluralized into a method
        pluralized_name = if name[-1] == 's'
          name
        else
          name + 's'
        end

        # TODO: Remove from db.
        remove_table_sql = "DROP TABLE #{pluralized_name}"
        db.execute(remove_table_sql)
      end
    end
  end
end