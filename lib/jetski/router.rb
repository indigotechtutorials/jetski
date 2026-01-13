class Jetski
  class Router
    include Parser
    attr_reader :server, :routes, :crud_routes
    def initialize(server)
      @server = server
      @crud_routes = []
    end

    def call
      browser_support
      fetch_routes
      host_routes
      host_crud_routes
      host_assets
    end

    def host_routes
      crud_actions = %w(new create show index edit update destroy)
      routes.each do |af_route|
        if crud_actions.include?(af_route[:action_name]) && (af_route[:url] != '/')
          @crud_routes << af_route
          next 
          # We need to have only one server block for routes with handle crud enabled
        end
        Host::Controller.new(server, **af_route).call
      end
    end

    def host_crud_routes
      crud_routes_for_controller = crud_routes.group_by { |route| route[:controller_path] }
      crud_routes_for_controller.each do |controller_path, controller_routes|
        Host::Crud.new(server, controller_routes, **controller_routes.first).call
      end
    end

    def host_assets
      host_css && host_images && host_javascript && host_javascript_helpers
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

    def host_javascript_helpers
      server.mount_proc "/reactive-form.js" do |req, res|
        res.content_type = "text/javascript"
        res.body = File.read(File.join(__dir__, 'frontend/javascript_helpers.js'))
      end
    end

    # routes to help browser default requests etc. prevent breakage
    def browser_support
      server.mount_proc "/favicon.ico" do |req, res|
        res.status = 204  # No Content
      end
    end
  private
    def fetch_routes
      @routes ||= compile_routes
    end
  end
end