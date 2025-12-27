require 'thor'
module JetskiCLIHelpers
  class Destroy < Thor
    include Thor::Actions
    desc "controller NAME ACTION_NAMES", "Destroys a controller"
    def controller(name, *actions)
      controller_file_path = "app/controllers/#{name}_controller.rb"
      remove_file(controller_file_path)
      view_folder = "app/views/#{name}"
      remove_dir(view_folder)
    end

    desc "model NAME ACTION_NAMES", "Destroys a model"
    def model(name, *actions)
      model_file_path = "app/models/#{name}.rb"
      remove_file(controller_file_path)
      # TODO: Remove from db.
    end
  end
end