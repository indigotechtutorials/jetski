Dir[File.join('./app', 'controllers', '*.rb')].each { |file| require file }

module Jetski
  class SplashRouter
    attr_reader :server
    def initialize(server)
      @server = server
    end
    def call
      parse_routes && host_assets
    end

    def parse_routes
      # Convert routes file into render of correct controller and action
      routes_file = "config/routes.rb"

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
          controller_class = Object.const_get("#{controller_name.capitalize}Controller")
          controller = controller_class.new(res)
          controller.action_name = action_name
          controller.controller_name = controller_name
          controller.send(action_name)
          controller.render
        end
      end
    end

    def host_assets
      # Render css via url
      css_files = Dir[File.join('./app', 'assets', 'stylesheets', '*.css')]
      css_files.each do |file_path|
        filename = file_path.split("/").last
        asset_url = "/assets/#{filename}"
        server.mount_proc asset_url do |req, res|
          res.body = File.read("app/assets/stylesheets/#{filename}")
        end
      end
    end
  end
end