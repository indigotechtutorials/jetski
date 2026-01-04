module Jetski
  class Router
    module Host
      class Crud < Base
        # Responsible for hosting auto crud routes
        def initialize(server, controller_routes, **server_options)
          server_options[:url] = server_options[:controller_path]
          super(server, **server_options)
        end

        def call
          super do
            # handle inside of call
            # check req/res objects
            # set res.body
            # Check request url and determine what url it was trying to access.
            req_path = req.request_uri.path
            custom_route_options = all_server_options.dup
            custom_route_options.tap do |opts|
              case req_path
              when controller_path # /posts
                  # Override attributes needed for rendering correct action /posts -> #index
                opts[:action_name] = "index"
              end
            end
            @controller_host = Jetski::Router::Host::Controller.new(server, **custom_route_options)
            @controller_host.res = res
            @controller_host.req = req
            @controller_host.fetch_controller_class
            @controller_host.call_controller
          end
        end
      end
    end
  end
end