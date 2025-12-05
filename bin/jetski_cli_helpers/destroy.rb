require 'thor'
module JetskiCLIHelpers
  class Destroy < Thor
    include Thor::Actions
    desc "controller NAME ACTION_NAMES", "Destroys a controller with matching actions"
    def controller(name, *actions)
      controller_file_path = "app/controllers/#{name}_controller.rb"
      remove_file(controller_file_path)
      actions.each do |action_name|
        view_folder = "app/views/#{name}"
        remove_dir(view_folder)
      end
    end
  end
end