require 'thor'
module JetskiCLIHelpers
  class Generate < Thor
    include Thor::Actions
    desc "controller NAME ACTION_NAMES", "Create a controller with matching actions"
    def controller(name, *actions)
      controller_file_path = "app/controllers/#{name}_controller.rb"
      copy_file("controllers/example_controller", controller_file_path)
      gsub_file(controller_file_path, /CONTROLLER_NAME/, name.capitalize)
      actions.each do |action_name|
        action_content = "def #{action_name}\nend\nACTION_NAME"
        gsub_file(controller_file_path, /ACTION_NAME/, action_content.strip)
        path_to_view = "app/views/#{name}/#{action_name}.html"

        empty_directory("app/views/#{name}")
        copy_file("views/example.html", path_to_view)
        gsub_file(path_to_view, /CONTROLLER_NAME/, name)
        gsub_file(path_to_view, /ACTION_NAME/, action_name)
        gsub_file(path_to_view, /PATH_TO_VIEW/, path_to_view)
      end
      gsub_file(controller_file_path, /ACTION_NAME/, '')
    end
        
    def self.source_root
      File.join(File.dirname(__FILE__), '..', 'templates')
    end
  end
end