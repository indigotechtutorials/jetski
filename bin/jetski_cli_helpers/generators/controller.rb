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
        all_controller_actions_content = ''

        default_controller_code = <<~CONTROLLER
          def #{name}_params
            {
              #{
                field_names.map do |field|
                  # TODO: Move this into a sharable method
                  param_name = field.split(":")[0]
                  "#{param_name}: params['#{pluralized_name}']['#{param_name}']"
                end.join(",\n")
              }
            }
          end
        CONTROLLER

        actions.each.with_index do |action_name, idx|
          # TODO: need to use correct action code for crud routes
          # default
          action_content = ""

          if field_names
            case action_name
            when "new"
              action_content = "@post = Post.new"
            when "create"
              action_content = <<~ACTION_CONTENT
                @post = Post.create(post_params)
                redirect_to "/posts/" + @post.id.to_s
              ACTION_CONTENT
            when "show"
              action_content = "@post = Post.find(params[:id])"
            when "edit"
              action_content = "@post = Post.find(params[:id])"
            when "update"
              action_content = <<~ACTION_CONTENT
                @post = Post.find(params[:id])
                @post.update(post_params)
                redirect_to "/posts/" + @post.id.to_s
              ACTION_CONTENT
            when "destroy"
              action_content = <<~ACTION_CONTENT
                @post = Post.find(params[:id])
                @post.destroy
                redirect_to "/posts"
              ACTION_CONTENT
            when "index"
              action_content = "@posts = Post.all"
            end
          end

          action_method_content = <<~ACTION_CONTENT
            def #{action_name}
              #{action_content}
            end
          ACTION_CONTENT
          
          action_nl_seperator = ((idx + 1) != actions.size) ? "\n\n" : ""
          all_controller_actions_content += "#{indent_code(action_method_content, 1)}#{action_nl_seperator}"
          
          # Render views

          
          if !["create", "create", "update", "destroy"].include?(action_name)
            empty_directory("app/views/#{pluralized_name}")
            
            # For new, show, edit, index actions
            path_to_view = "app/views/#{pluralized_name}/#{action_name}.html.erb"

            create_file(path_to_view)
            
            # Default
            action_template_content = <<~EXAMPLEFILE
              <h1> #{pluralized_name}##{action_name} </h1>
              <p> edit the content of this page at app/views/#{path_to_view}/#{action_name}.html.erb </p>
            EXAMPLEFILE

            if field_names
              case action_name
              when "new"
                _new_page = ""
                _new_page += "<h1> New #{pluralized_name} </h1>\n"
                _new_page += "<form action='/#{pluralized_name}' method='POST'>\n"
                field_names.each do |field|
                  sanitized_field = field.split(":")[0]
                  _new_page += "<input name='#{pluralized_name}[#{sanitized_field}]'/>\n"
                end
                _new_page += "<button type='submit'>Create #{name}</button>\n"
                _new_page += "</form>\n"
                action_template_content = _new_page
              when "show"
                _show_page = ""
                _show_page += "<h1>Viewing your #{name}</h1>\n"
                _show_page += "<a href='/#{pluralized_name}'>Back to #{pluralized_name}</a>\n"
                _show_page += "<a href='/#{pluralized_name}/<%= @post.id %>/edit'>Edit #{name}</a>\n"
                field_names.each do |field|
                  sanitized_field = field.split(":")[0]
                  _show_page += "<p> #{sanitized_field}: <%= @#{name}.#{sanitized_field} %> </p>\n"
                end
                action_template_content = _show_page
              when "edit"
                _edit_page = ""
                _edit_page += "<h1> Edit #{name} </h1>\n"
                _edit_page += "<form action='/#{pluralized_name}/<%= @post.id %>' method='PUT'>\n"
                field_names.each do |field|
                  sanitized_field = field.split(":")[0]
                  _edit_page += "<input name='#{pluralized_name}[#{sanitized_field}]'/>\n"
                end
                _edit_page += "<button type='submit'>Update #{name}</button>\n"
                _edit_page += "</form>\n"
                action_template_content = _edit_page
              when "index"
                _index_page = ""
                _index_page += "<h1>All #{pluralized_name}</h1>\n"
                _index_page += "<a href='/#{pluralized_name}/new'>Create new #{name}</a>\n"
                _index_page += "<% @#{pluralized_name}.each do |#{name}| %>\n"
                field_names.each do |field|
                  # TODO: Move this to shared method
                  sanitized_field = field.split(":")[0]
                  _index_page += "<p> #{sanitized_field}: <%= #{name}.#{sanitized_field} %> </p>\n"
                end
                _index_page += "<% end %>\n"
                action_template_content = _index_page
              end
            end
            
            append_to_file path_to_view, action_template_content

            say "🌊 View your new page at http://localhost:8000/#{pluralized_name}/#{action_name}"
          end
        end
        append_to_file controller_file_path, <<~CONTROLLER
          class #{formatted_controller_name}Controller < Jetski::BaseController
            #{all_controller_actions_content}
            #{default_controller_code}
          end
        CONTROLLER
      end
    end
  end
end