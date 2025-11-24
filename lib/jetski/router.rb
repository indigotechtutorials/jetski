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
      routes_file = File.join(Jetski.app_root, "config/routes.rb")

      File.readlines(routes_file, chomp: true).each do |line|
        route_action = line.split(" ")[0]
        controller_mapping = line.split(" ")[1].gsub(/\"/, "")
        controller_name = controller_mapping.split("#")[0]
        action_name = controller_mapping.split("#")[1]
        
        served_url = case route_action
        when "root"
          "/"
        end
        
        server.mount_proc served_url do |req, res|
          constantized_controller = "#{controller_name.capitalize}Controller"
          path_to_defined_controller = File.join(Jetski.app_root, "app/controllers/#{controller_name}_controller.rb")
          require_relative path_to_defined_controller
          found_error = false
          begin
            controller_class = Object.const_get(constantized_controller)
          rescue NameError
            found_error = true
            # TODO: Move this into a method that can render a styled error to page.  
            res.body = "#{constantized_controller} is not defined. Please create a file app/controllers/#{controller_name}.rb"
          end
          if found_error == false # Continue unless error found
            controller = controller_class.new(res)
            controller.action_name = action_name
            controller.controller_name = controller_name
            controller.send(action_name)
            controller.render
          end
        end
      end
    end

    def host_assets
      # Render css via url
      css_files = Dir[File.join(Jetski.app_root,'app/assets/stylesheets/*.css')]
      css_files.each do |file_path|
        filename = file_path.split("/").last
        asset_url = "/assets/#{filename}"
        server.mount_proc asset_url do |req, res|
          res.body = File.read(File.join(Jetski.app_root,"app/assets/stylesheets/#{filename}"))
        end
      end
    end
  end
end