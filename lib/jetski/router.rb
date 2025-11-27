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
      # Convert routes file into render of correct controller and action
      routes_file = File.join(Jetski.app_root, "config/routes")

      File.readlines(routes_file, chomp: true).each do |line|
        route_action, served_url, controller_name, action_name = line.split(" ")
        server.mount_proc served_url do |req, res|
          errors = []
          if (route_action.upcase != req.request_method)
            errors << "Wrong request was performed"
          end
          # TODO: Fix the fact that we are always setting res.body to something here. 
          # Theres no way to return. We need to organize into case statement or if/else type
          
          if errors.empty?
            constantized_controller = "#{controller_name.capitalize}Controller"
            path_to_defined_controller = File.join(Jetski.app_root, "app/controllers/#{controller_name}_controller.rb")
            require_relative path_to_defined_controller
            begin
              controller_class = Object.const_get(constantized_controller)
            rescue NameError
              errors << "#{constantized_controller} is not defined. Please create a file app/controllers/#{controller_name}.rb"
            end
          end

          if errors.empty? # Continue unless error found
            controller = controller_class.new(res)
            controller.action_name = action_name
            controller.controller_name = controller_name
            controller.send(action_name)
            # Render matching HTML template for GET requests only
            controller.render if route_action.upcase == "GET"
          end

          if errors.any?
            res.body = errors.join(", ")
          end
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