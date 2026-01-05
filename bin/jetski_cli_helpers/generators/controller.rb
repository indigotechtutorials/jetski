module JetskiCLIHelpers
  module Generators
    module Controller
      def generate_controller(name, *actions, **extra_options)
        field_names = extra_options[:field_names]
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
            # How to access model created inside of controller generator?
            create_file(path_to_view)
            

            if field_names
              case action_name
              when "new"
                _new_page = ""
                _new_page += "<h1> New #{pluralized_name} </h1>\n"
                _new_page += "<form action='/#{pluralized_name}' method='POST'>\n"
                field_names.each do |field|
                  _new_page += "<input name='#{pluralized_name}[#{field}]'/>\n"
                end
                _new_page += "<button type='submit'>Create #{name}</button>\n"
                _new_page += "</form>\n"
                append_to_file path_to_view, _new_page
              when "show"
                _show_page = ""
                _show_page += "<h1>Viewing your #{name}</h1>\n"
                _show_page += "<a href='/#{pluralized_name}'>Back to #{pluralized_name}</a>\n"
                _show_page += "<a href='/#{pluralized_name}/<%= @post.id %>/edit'>Edit #{name}</a>\n"
                field_names.each do |field|
                  _show_page += "<p> #{field}: <%= @#{name}.#{field} %> </p>\n"
                end
                append_to_file path_to_view, _show_page
              when "edit"
                _edit_page = ""
                _edit_page += "<h1> Edit #{name} </h1>\n"
                _edit_page += "<form action='/#{pluralized_name}/<%= @post.id %>' method='PUT'>\n"
                field_names.each do |field|
                  _edit_page += "<input name='#{pluralized_name}[#{field}]'/>\n"
                end
                _edit_page += "<button type='submit'>Update #{name}</button>\n"
                _edit_page += "</form>\n"
                append_to_file path_to_view, _edit_page
              when "index"
                _index_page = ""
                _index_page += "<h1>All #{pluralized_name}</h1>\n"
                _index_page += "<a href='/#{pluralized_name}/new'>Create new #{name}</a>\n"
                _index_page += "<% @#{pluralized_name}.each do |#{name}| %>\n"
                field_names.each do |field|
                  _index_page += "<p> #{field}: <%= #{name}.#{field} %> </p>\n"
                end
                _index_page += "<% end %>\n"
                append_to_file path_to_view, _index_page
              else
                append_to_file path_to_view, <<~EXAMPLEFILE
                  <h1> #{pluralized_name}##{action_name} </h1>
                  <p> edit the content of this page at app/views/#{path_to_view}/#{action_name}.html.erb </p>
                EXAMPLEFILE
              end
            end
              
            say "🌊 View your new page at http://localhost:8000/#{pluralized_name}/#{action_name}"
          end
        end
      end
    end
  end
end