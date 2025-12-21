# This is the base controller of the library
module Jetski
  class BaseController
    include ReactiveForm
    attr_accessor :action_name, :controller_name, :controller_path, 
      :params, :cookies
    attr_reader :res, :performed_render
    attr_writer :root, :path, :request_method

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

    def set_cookie(name, value)
      res.cookies.push WEBrick::Cookie.new(name.to_s, value || "")
    end

    def get_cookie(name)
      cookies&.find { |c| c.name == name.to_s }&.value
    end

    def is_root?
      @root == true
    end

    def custom_path
      @path
    end
    
    def custom_request_method
      @request_method
    end

  private
    def render_template_file
      view_render = page_with_layout.gsub("\n</head>", "#{content_for_head}\n</head>")
      res.content_type = "text/html"
      res.body = view_render
    end

    def page_with_layout
      process_erb(File.read(File.join(views_folder, "layouts/application.html.erb"))) do
        process_erb(File.read(File.join(views_folder, path_to_controller, "#{action_name}.html.erb")))
      end
    end

    def content_for_head
      _content_for_head = ''

      application_css_file = File.join(assets_folder, "stylesheets", "application.css")
      if File.exist? application_css_file
        _content_for_head += "<link rel='stylesheet' href='/application.css'>\n"
      end

      controller_css_file = File.join(assets_folder, "stylesheets", "#{path_to_controller}.css")
      if File.exist? controller_css_file
        _content_for_head += "<link rel='stylesheet' href='/#{path_to_controller}.css'>\n"
      end
      
      application_js_file = File.join(assets_folder, "javascript", "application.js")
      if File.exist? application_js_file
        _content_for_head += "<script src='application.js' defer></script>\n"
      end

      controller_js_file = File.join(assets_folder, "javascript", "#{path_to_controller}.js")
      if File.exist? controller_js_file
        _content_for_head += "<script src='/#{path_to_controller}.js' defer></script>\n"
      end

      # Add reactive form JS code
      _content_for_head += "<script src='/reactive-form.js' defer></script>\n"

      _content_for_head
    end
    
    def views_folder 
      File.join(Jetski.app_root, 'app/views')
    end

    def assets_folder
      File.join(Jetski.app_root, 'app/assets')
    end

    def path_to_controller 
      controller_path[1..-1]
    end

    def process_erb(content)
      template = ERB.new(content)
      template.result(binding)
    end
  end
end