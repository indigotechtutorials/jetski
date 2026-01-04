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
            # Override attributes needed for rendering correct action /posts -> #index
            custom_route_options.tap do |opts|
              case req_path
              when controller_path # /posts
                opts[:action_name] = "index"
              when "#{controller_path}/new"
                opts[:action_name] = "new"
              else
                url_param = req_path.split("#{controller_path}/")[-1]
                case
                when url_param.match(/\d(\/edit)/)
                  # Edit page
                  opts[:action_name] = "edit"
                when url_param.match(/\d\z/)
                  # matches only id 5 with no additional characters
                  # Determine if show/update/destroy from request_method
                  case req.request_method
                  when "GET"
                    opts[:action_name] = "show"
                  when "PUT"
                    opts[:action_name] = "update"
                  when "DELETE"
                    opts[:action_name] = "destroy"
                  end
                end
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