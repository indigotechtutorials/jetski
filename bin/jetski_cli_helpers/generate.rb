require 'thor'
module JetskiCLIHelpers
  class Generate < Thor
    include Thor::Actions
    desc "controller NAME ACTION_NAMES", "Create a controller with matching actions"
    def controller(name, *actions)
      controller_file_path = "app/controllers/#{name}_controller.rb"
      copy_file("controllers/example_controller", controller_file_path)
      gsub_file(controller_file_path, /CONTROLLER_NAME/, name.capitalize)
      actions.each.with_index do |action_name, idx|
        action_content = "def #{action_name}\n  end"
        if actions.size < (idx + 1)
          action_content += "\nACTION_NAME"
        end
        gsub_file(controller_file_path, /ACTION_NAME/, action_content.strip)
        path_to_view = "app/views/#{name}/#{action_name}.html"

        empty_directory("app/views/#{name}")
        copy_file("views/example.html", path_to_view)
        gsub_file(path_to_view, /CONTROLLER_NAME/, name)
        gsub_file(path_to_view, /ACTION_NAME/, action_name)
        gsub_file(path_to_view, /PATH_TO_VIEW/, path_to_view)
        say "🌊 View your new page at http://localhost:8000/#{name}/#{action_name}"
      end
    end
        
    def self.source_root
      File.join(File.dirname(__FILE__), '..', 'templates')
    end
  end
end