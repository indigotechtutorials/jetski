module Jetski
  class Router
    module Parser
      extend self
      def compile_routes
        auto_found_routes = []
        controller_file_paths = Dir.glob([File.join(Jetski.app_root, 'app', 'controllers', '**', '*_controller.rb')])
        controller_file_paths.each do |file_path| 
          controller_file_name = file_path.split('app/controllers')[1]
          controller_path = controller_file_name.gsub(/_controller.rb/, '')
          controller_name = controller_path.split("/").last
          controller_classname = controller_path.split("/").reject(&:empty?).map(&:capitalize).join("::") + "Controller"
          controller_file_readlines = File.readlines(file_path)
          controller_file_readlines.each.with_index do |line, idx| 
            strp_line = line.strip 
            if strp_line.start_with?('def')
              action_name = strp_line.split("def").last.strip
              base_opts = { 
                controller_classname: controller_classname, 
                controller_file_name: controller_file_name,
                controller_name: controller_name,
                controller_path: controller_path,
              }
              case action_name
              when "new"
                auto_found_routes << base_opts.merge({
                  url: controller_path + "/new",
                  method: "GET",
                  action_name: action_name,
                })
              when "create"
                auto_found_routes << base_opts.merge({
                  url: controller_path,
                  method: "POST",
                  action_name: action_name,
                })
              when "show"
                auto_found_routes << base_opts.merge({
                  url: controller_path + "/:id",
                  method: "GET",
                  action_name: action_name,
                })
              when "edit"
                auto_found_routes << base_opts.merge({
                  url: controller_path + "/:id/edit",
                  method: "GET",
                  action_name: action_name,
                })
              when "update"
                auto_found_routes << base_opts.merge({
                  url: controller_path + "/:id",
                  method: "PUT",
                  action_name: action_name,
                })
              when "destroy"
                auto_found_routes << base_opts.merge({
                  url: controller_path + "/:id",
                  method: "DELETE",
                  action_name: action_name,
                })
              else
                method_route_options = controller_file_readlines[(idx - 2)..(idx - 1)].map(&:strip)
                custom_request_method = method_route_options.find { |line| line.start_with? "request_method" }
                custom_request_method = if custom_request_method
                  custom_request_method.split(" ")[1].gsub('"', '').upcase
                else
                  "GET"
                end
                custom_path_option = method_route_options.find { |line| line.start_with? "path" }
                check_root = controller_file_readlines[idx - 1].strip
                url_to_use = if check_root.include?("root")
                  "/"
                else
                  if custom_path_option
                    custom_path_option.split(" ")[1].gsub('"', '')
                  else
                    url_friendly_action_name = action_name.split("_").join("-")
                    controller_path + "/#{url_friendly_action_name}"
                  end
                end
                auto_found_routes << base_opts.merge({
                  url: url_to_use,
                  method: custom_request_method,
                  action_name: action_name,
                })
              end
            end
          end
        end
        auto_found_routes
      end
    end
  end
end