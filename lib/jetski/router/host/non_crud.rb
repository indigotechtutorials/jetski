module Jetski
  class Router
    module Host
      class NonCrud < Base
        # Responsibility is to host the route with methods to route url to controller action
        # URL -> Controller#Action
        attr_reader :controller_name, :action_name, :controller_file_name,
            :controller_path, :controller_class
        
        def initialize(server, **af_route)
          super(server, **af_route)
          @controller_classname = af_route[:controller_classname]
          @controller_name = af_route[:controller_name]
          @action_name = af_route[:action_name]
          @controller_file_name = af_route[:controller_file_name]
          @controller_path = af_route[:controller_path]
        end

        def call
          super do
            fetch_controller_class if errors.empty?
            call_controller if errors.empty?
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
end