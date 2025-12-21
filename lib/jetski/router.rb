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
            controller.params = OpenStruct.new(JSON.parse(req.body)) if req.body
            controller.send(action_name)
            if !controller.performed_render && (request_method.upcase == "GET")
              controller.render
            end
          end

          if errors.any?
            res.body = errors.join(", ")
          end
        end
      end
    end

    def host_assets
      host_css && host_images && host_javascript && host_reactive_form_js
    end

    def host_css
      css_files = Dir[File.join(Jetski.app_root,'app/assets/stylesheets/**/*.css')]
      css_files.each do |file_path|
        filename  = file_path.split("app/assets/stylesheets/").last
        asset_url = "/#{filename}"
        server.mount_proc asset_url do |req, res|
          res.content_type = "text/css"
          res.body = File.read(File.join(Jetski.app_root,"app/assets/stylesheets/#{filename}"))
        end
      end
    end

    def host_images
      file_ext_types = ["png", "jpg"] # TODO: Expand this to support more types of images.
      image_files = Dir.glob(
        file_ext_types.map { |ext| File.join(Jetski.app_root, "app/assets/images/*.#{ext}")  }
      )
      image_files.each do |file_path|
        filename = file_path.split("/").last
        asset_url = "/#{filename}"
        server.mount_proc asset_url do |req, res|
          res.content_type = "image/*"
          res.body = File.read(File.join(Jetski.app_root,"app/assets/images/#{filename}"))
        end
      end
    end

    def host_javascript
      js_files = Dir[File.join(Jetski.app_root,'app/assets/javascript/**/*.js')]
      js_files.each do |file_path|
        filename  = file_path.split("app/assets/javascript/").last
        asset_url = "/#{filename}"
        server.mount_proc asset_url do |req, res|
          res.content_type = "text/javascript"
          res.body = File.read(File.join(Jetski.app_root,"app/assets/javascript/#{filename}"))
        end
      end
    end

    def host_reactive_form_js
      server.mount_proc "/reactive-form.js" do |req, res|
        res.content_type = "text/javascript"
        res.body = File.read(File.join(__dir__, 'frontend/reactive_form.js'))
      end
    end
  end
end