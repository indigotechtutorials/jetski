module Jetski
  class Router
    include Parser
    attr_reader :server
    def initialize(server)
      @server = server
    end

    def call
      host_routes && host_assets
    end

    def host_routes
      routes = compile_routes
      routes.each do |af_route|
        served_url = af_route[:url]
        request_method = af_route[:method]
        controller_classname = af_route[:controller_classname]
        controller_name = af_route[:controller_name]
        action_name = af_route[:action_name]
        controller_file_name = af_route[:controller_file_name]
        controller_path = af_route[:controller_path]

        server.mount_proc served_url do |req, res|
          errors = []
          if (request_method!= req.request_method)
            errors << "Wrong request was performed"
          end
          if errors.empty?
            path_to_defined_controller = File.join(Jetski.app_root, "app/controllers/#{controller_file_name}")
            require_relative path_to_defined_controller
            begin
              controller_class = Object.const_get(controller_classname)
            rescue NameError
              errors << "#{controller_classname} is not defined. Please create a file app/controllers/#{controller_file_name}"
            end
          end

          if errors.empty?
            controller = controller_class.new(res)
            controller.action_name = action_name
            controller.controller_name = controller_name
            controller.controller_path = controller_path
            controller.send(action_name)
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
      file_ext_types = ["png", "jpg"]
      image_files = Dir.glob(
        file_ext_types.map { |ext| File.join(Jetski.app_root, "app/assets/images/*.#{ext}")  }
      )
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