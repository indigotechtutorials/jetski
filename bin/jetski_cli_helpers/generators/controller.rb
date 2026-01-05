module JetskiCLIHelpers
  module Generators
    module Controller
      def generate_controller(name, *actions)
        pluralized_name = if name[-1] == 's'
          name
        else
          name + 's'
        end

        formatted_controller_name = pluralized_name.split("_").map(&:capitalize).join
        controller_file_path = "app/controllers/#{pluralized_name}_controller.rb"
        create_file controller_file_path
        append_to_file controller_file_path, <<~CONTROLLER
          class #{formatted_controller_name}Controller < Jetski::BaseController

          end
        CONTROLLER

        actions.each.with_index do |action_name, idx|
          action_content = <<~ACTION_CONTENT
            def #{action_name}

            end
          ACTION_CONTENT
          action_nl_seperator = ((idx + 1) != actions.size) ? "\n\n" : ""
          insert_into_file(controller_file_path, "#{indent_code(action_content, 1)}#{action_nl_seperator}", before: "\nend")
          
          if !["create", "create", "update", "destroy"].include?(action_name)
            # For new, show, edit, index actions
            path_to_view = "app/views/#{pluralized_name}/#{action_name}.html.erb"

            empty_directory("app/views/#{pluralized_name}")
            create_file(path_to_view)

            # How to access model created inside of controller generator?
            
            append_to_file path_to_view, <<~EXAMPLEFILE
              <h1> #{pluralized_name}##{action_name} </h1>
              <p> edit the content of this page at app/views/#{path_to_view}/#{action_name}.html.erb </p>
            EXAMPLEFILE
              
            say "🌊 View your new page at http://localhost:8000/#{pluralized_name}/#{action_name}"
          end
        end
      end
    end
  end
end