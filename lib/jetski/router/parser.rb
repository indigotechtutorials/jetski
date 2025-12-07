module Jetski
  class Router
    module Parser
      extend self
      def compile_routes
        auto_found_routes = []
        controller_file_paths = Dir.glob([File.join(Jetski.app_root, 'app', 'controllers', '**', '*_controller.rb')])
        controller_file_paths.each do |file_path|
          require_relative file_path
          controller_file_name = file_path.split('app/controllers')[1]
          controller_path = controller_file_name.gsub(/_controller.rb/, '')
          controller_name = controller_path.split("/").last
          controller_classname = controller_path.split("/").reject(&:empty?).map(&:capitalize).join("::") + "Controller"
          controller_class = Module.const_get(controller_classname)
          action_names = controller_class.instance_methods(false)
          base_opts = { 
            controller_classname: controller_classname, 
            controller_file_name: controller_file_name,
            controller_name: controller_name,
            controller_path: controller_path,
          }
          action_names.each do |action_name|
            action_name = action_name.to_s
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
              tmp_controller_instance = controller_class.new("")
              tmp_controller_instance.send(action_name)
              is_root = tmp_controller_instance.is_root?
              custom_path = tmp_controller_instance.custom_path 
              url_to_use = if is_root
                "/"
              elsif custom_path
                custom_path
              else
                url_friendly_action_name = action_name.split("_").join("-")
                controller_path + "/#{url_friendly_action_name}"
              end
              custom_request_method = tmp_controller_instance.custom_request_method

              auto_found_routes << base_opts.merge({
                url: url_to_use,
                method: custom_request_method || "GET",
                action_name: action_name,
              })
            end
          end
        end
        auto_found_routes
      end
    end
  end
end