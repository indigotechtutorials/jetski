# This is the base controller of the library
module Jetski
  class BaseController
    attr_accessor :action_name, :controller_name, :controller_path, :params
    attr_reader :res
    attr_reader :performed_render

    class << self
      def request_method(method)
        # Really just a shell method since Im using File.readlines to use the logic in routes.
      end

      def root
        # another shell method
      end

      def path(location)
        # Another shell method
      end
    end

    def initialize(res)
      @res = res
      @performed_render = false
    end

    # Method to render matching view with controller_name/action_name
    
    def render(**args)
      @performed_render = true
      request_status = args[:status] || 200
      res.status = request_status
      if args[:text]
        res.content_type = "text/plain"
        res.body = "#{args[:text]}\n"
        return
      end

      if args[:json]
        res.content_type = "application/json"
        res.body = args[:json].to_json
        return
      end
      
      render_template_file
    end

    def redirect_to(url)
      @performed_render = true
      res.set_redirect(WEBrick::HTTPStatus::Found, url)
    end

  private
    def render_template_file
      views_folder = File.join(Jetski.app_root, 'app/views')
      assets_folder = File.join(Jetski.app_root, 'app/assets/stylesheets')
      layout_content = File.read(File.join(views_folder, "layouts/application.html"))
      path_to_controller = controller_path[1..-1]
      page_content = File.read(File.join(views_folder, path_to_controller, "#{action_name}.html"))
      page_with_layout = layout_content.gsub("YIELD_CONTENT", page_content)
      action_css_file = File.join(assets_folder, "#{path_to_controller}.css")
      css_content = if File.exist? action_css_file
        "<link rel='stylesheet' href='/#{path_to_controller}.css'>"
      else
        ''
      end
      page_with_css = page_with_layout.gsub("DYNAMIC_CSS", css_content)
      res.content_type = "text/html"
      res.body = page_with_css
    end
  end
end