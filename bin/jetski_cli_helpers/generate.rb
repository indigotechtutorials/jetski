require 'thor'
module JetskiCLIHelpers
  class Generate < Thor
    include Thor::Actions, JetskiCLIHelpers::SharedMethods, 
      Jetski::Database::Base
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
        action_nl_seperator = ((idx + 1) != actions.size) ? "\n\n" : ""
        insert_into_file(controller_file_path, "#{indent_code(action_content, 1)}#{action_nl_seperator}", before: "\nend")
        
        if !["create", "create", "update", "destroy"].include?(action_name)
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
    end

    desc "model NAME FIELD_NAMES", "Creates a model with matching fields"
    def model(name, *field_names)
      db.execute create_table_sql(table_name: name, field_names: field_names)
      model_file_path = "app/models/#{name}.rb"
      create_file model_file_path
      append_to_file model_file_path, <<~MODEL
        class #{name.capitalize} < Jetski::Model
          
        end
      MODEL
    end
  end
end