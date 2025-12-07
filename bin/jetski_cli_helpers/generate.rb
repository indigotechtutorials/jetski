require 'thor'
module JetskiCLIHelpers
  class Generate < Thor
    include Thor::Actions
    desc "controller NAME ACTION_NAMES", "Create a controller with matching actions"
    def controller(name, *actions)
      controller_file_path = "app/controllers/#{name}_controller.rb"
      create_file controller_file_path
      append_to_file controller_file_path, <<~CONTROLLER
        class #{name.capitalize}Controller < Jetski::BaseController

        end
      CONTROLLER

      actions.each.with_index do |action_name, idx|
        action_content = <<~ACTION_CONTENT
          def #{action_name}

          end
        ACTION_CONTENT
        insert_into_file(controller_file_path, indent_code(action_content, 1), before: "\nend")
        path_to_view = "app/views/#{name}/#{action_name}.html.erb"

        empty_directory("app/views/#{name}")
        create_file(path_to_view)
        append_to_file path_to_view, <<~EXAMPLEFILE
          <h1> #{name}##{action_name} </h1>
          <p> edit the content of this page at app/views/#{path_to_view}/#{action_name}.html.erb </p>
        EXAMPLEFILE
          
        say "🌊 View your new page at http://localhost:8000/#{name}/#{action_name}"
      end
    end
        
  private
    def indent_code(code, level = 1)
      code.strip.split("\n").map { |l| (1..level).map { |lvl| "  " }.join + l }.join("\n")
    end
  end
end