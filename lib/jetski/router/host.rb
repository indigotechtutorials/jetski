module Jetski
  class Router
    class Host
      # Responsibility is to host the route with methods to route url to controller action
      # URL -> Controller#Action
      attr_reader :server, :errors, :served_url, :request_method, :controller_classname,
        :controller_name, :action_name, :controller_file_name,
        :controller_path, :controller_class, :req, :res
      def initialize(server, af_route)
        @server = server
        @errors = []
        @served_url = af_route[:url]
        @request_method = af_route[:method]
        @controller_classname = af_route[:controller_classname]
        @controller_name = af_route[:controller_name]
        @action_name = af_route[:action_name]
        @controller_file_name = af_route[:controller_file_name]
        @controller_path = af_route[:controller_path]
      end

      def call
        server.mount_proc served_url do |req, res|
          @req = req
          @res = res
          check_request_method
          fetch_controller_class if errors.empty?
          call_controller if errors.empty?

          if errors.any?
            res.body = errors.join(", ")
          end
        end
      end
    private
      def check_request_method
        if (request_method != req.request_method)
          @errors << "Wrong request was performed"
        end
      end

      def fetch_controller_class
        path_to_defined_controller = File.join(Jetski.app_root, "app/controllers/#{controller_file_name}")
        require_relative path_to_defined_controller
        begin
          @controller_class = Object.const_get(controller_classname)
        rescue NameError
          @errors << "#{controller_classname} is not defined. Please create a file app/controllers/#{controller_file_name}"
        end
      end

      def call_controller
        controller = controller_class.new(res)
        controller.action_name = action_name
        controller.controller_name = controller_name
        controller.controller_path = controller_path
        if req.body
          controller.params = parse_body(req.body, req.content_type)
        end
        controller.cookies = req.cookies
        controller.send(action_name)
        if !controller.performed_render && (request_method.upcase == "GET")
          controller.render
        end
      end

      def parse_body(body, content_type = '')
        case content_type
        when "application/x-www-form-urlencoded"
          Rack::Utils.parse_nested_query body
        when "application/json"
          OpenStruct.new(JSON.parse(body))
        else
          body
        end
      end

    end
  end
end