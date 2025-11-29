module Jetski
  class Router
    attr_reader :server
    def initialize(server)
      @server = server
    end

    def call
      parse_routes && host_assets
    end

    def parse_routes
      # TODO: move from routes file to automatic routing.

      # Find all controllers and create automatic urls for them.
      
      auto_found_routes = []

      # Served urls is an array of objects

      controller_file_paths = Dir.glob([File.join(Jetski.app_root, 'app', 'controllers', '**', '*_controller.rb')])
      
      controller_file_paths.each do |file_path| 
        controller_file_name = file_path.split('app/controllers')[1]
        controller_as_url = controller_file_name.gsub(/_controller.rb/, '')
        controller_name = controller_as_url.split("/").last
        controller_classname = controller_as_url.split("/").reject(&:empty?).map(&:capitalize).join("::") + "Controller"
        controller_file_readlines = File.readlines(file_path)
        controller_file_readlines.each.with_index do |line, idx| 
          strp_line = line.strip 
          if strp_line.start_with?('def')
            action_name = strp_line.split("def").last.strip
            
            # Go thru and set routes based on method names
            base_opts = { 
              controller_classname: controller_classname, 
              controller_file_name: controller_file_name,
              controller_name: controller_name 
            }
            case action_name
            when "new"
              auto_found_routes << base_opts.merge({
                url: controller_as_url + "/new",
                method: "GET",
                action_name: action_name,
              })
            when "create"
              auto_found_routes << base_opts.merge({
                url: controller_as_url,
                method: "POST",
                action_name: action_name,
              })
            when "show"
              auto_found_routes << base_opts.merge({
                url: controller_as_url + "/:id",
                method: "GET",
                action_name: action_name,
              })
            when "edit"
              auto_found_routes << base_opts.merge({
                url: controller_as_url + "/:id/edit",
                method: "GET",
                action_name: action_name,
              })
            when "update"
              auto_found_routes << base_opts.merge({
                url: controller_as_url + "/:id",
                method: "PUT",
                action_name: action_name,
              })
            when "destroy"
              auto_found_routes << base_opts.merge({
                url: controller_as_url + "/:id",
                method: "DELETE",
                action_name: action_name,
              })
            else
              # AUTO setting method to GET we need to fix this.
            
              custom_req_method_check = controller_file_readlines[idx - 1].strip
              custom_request_method = if custom_req_method_check.include?("request_method")
                custom_req_method_check.split(" ")[1].gsub('"', '').upcase
              else
                "GET"
              end
              auto_found_routes << base_opts.merge({
                url: controller_as_url + "/#{action_name}",
                method: custom_request_method,
                action_name: action_name,
              })
            end
          end
        end
      end

      auto_found_routes.each do |af_route|
        served_url = af_route[:url]
        request_method = af_route[:method]
        controller_classname = af_route[:controller_classname]
        controller_name = af_route[:controller_name]
        action_name = af_route[:action_name]
        controller_file_name = af_route[:controller_file_name]

        server.mount_proc served_url do |req, res|
          errors = []
          if (request_method!= req.request_method)
            errors << "Wrong request was performed"
          end
          # TODO: Fix the fact that we are always setting res.body to something here. 
          # Theres no way to return. We need to organize into case statement or if/else type
          
          if errors.empty?
            path_to_defined_controller = File.join(Jetski.app_root, "app/controllers/#{controller_file_name}")
            require_relative path_to_defined_controller
            begin
              controller_class = Object.const_get(controller_classname)
            rescue NameError
              errors << "#{controller_classname} is not defined. Please create a file app/controllers/#{controller_file_name}"
            end
          end

          if errors.empty? # Continue unless error found
            controller = controller_class.new(res)
            controller.action_name = action_name
            controller.controller_name = controller_name
            controller.send(action_name)
            # Render matching HTML template for GET requests only
            if !controller.performed_render && (request_method.upcase == "GET")
              controller.render
            end
            # TODO: Need to setup redirects for other request types. POST/PUT/DELETE
          end

          if errors.any?
            res.body = errors.join(", ")
          end

          # TODO: Set response content/type and status when rendering/redirecting or head
        end
      end
    end

    def host_assets
      # Render stylesheets css via url
      host_css && host_images
    end

    def host_css
      css_files = Dir[File.join(Jetski.app_root,'app/assets/stylesheets/*.css')]
      css_files.each do |file_path|
        filename = file_path.split("/").last
        asset_url = "/#{filename}"
        server.mount_proc asset_url do |req, res|
          res.body = File.read(File.join(Jetski.app_root,"app/assets/stylesheets/#{filename}"))
        end
      end
    end

    def host_images
      # TODO: Expand this to support more types of images.
      
      image_files = Dir[
        File.join(Jetski.app_root, 'app/assets/images/*.jpg')
      ]
      image_files.each do |file_path|
        filename = file_path.split("/").last
        asset_url = "/#{filename}"
        server.mount_proc asset_url do |req, res|
          res.body = File.read(File.join(Jetski.app_root,"app/assets/images/#{filename}"))
        end
      end
    end
  end
end