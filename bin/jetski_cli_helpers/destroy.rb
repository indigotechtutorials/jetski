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
  end
end