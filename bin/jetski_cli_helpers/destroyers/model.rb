module JetskiCLIHelpers
  module Destroyers
    module Model
      def destroy_model(name)
        model_file_path = "app/models/#{name}.rb"
        remove_file(controller_file_path)
        # TODO: Remove from db.
      end
    end
  end
end