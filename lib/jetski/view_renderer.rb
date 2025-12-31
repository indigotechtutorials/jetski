module Jetski
  class ViewRenderer
    include Jetski::Helpers::ViewHelpers
    extend Jetski::Helpers::Delegatable
    
    attr_reader :errors, :controller
    delegate :res, :action_name, :controller_path, to: :controller
    
    def initialize(controller)
      @controller = controller
      @errors = []
    end

    def call
      res.content_type = "text/html"
      view_render = perform_view_render&.gsub("\n</head>", "#{content_for_head}\n</head>")
      return error_screen if errors.any?
      res.body = view_render
    end
  private
    def error_screen
      # TODO: Make better error screen
      res.body = "<h1> Errors: #{errors.map {|e| e }.join(", ")} </h1>"
    end

    def perform_view_render
      process_erb(File.read(File.join(views_folder, "layouts/application.html.erb"))) do
        process_erb(File.read(File.join(views_folder, path_to_controller, "#{action_name}.html.erb")))
      end
    end

    def process_erb(content)
      template = ERB.new(content)
      # Perserve instance variables to view render
      # @posts from controller to posts/index.html.erb

      grab_instance_variables
      template.result(binding)
    rescue => e
      @errors << e
      nil
    end

    def grab_instance_variables
      variables_from_controller = controller.instance_variables.filter { |var| !Jetski::BaseController::RESERVED_INSTANCE_VARIABLES.include?(var) }
      variables_from_controller.each do |inst_var|
        value = controller.instance_variable_get(inst_var)
        instance_variable_set(inst_var, value)
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
  end
end