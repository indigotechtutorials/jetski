module Jetski
  class Router
    module Host
      class Base
        attr_reader :server, :errors, :served_url, :request_method, :controller_classname, 
          :req, :res
        
        def initialize(server, **server_options)
          @server = server
          @errors = []
          @served_url = server_options[:url]
          @request_method = server_options[:method]
        end

        def call
          server.mount_proc served_url do |req, res|
            @req = req
            @res = res
            check_request_method
            yield
            if errors.any?
              res.body = errors.join(", ")
            end
          end
        end
      protected
        def fetch_controller_class
          path_to_defined_controller = File.join(Jetski.app_root, "app/controllers/#{controller_file_name}")
          require_relative path_to_defined_controller
          begin
            @controller_class = Object.const_get(controller_classname)
          rescue NameError
            @errors << "#{controller_classname} is not defined. Please create a file app/controllers/#{controller_file_name}"
          end
        end
      private
        def check_request_method
          if (request_method != req.request_method)
            @errors << "Wrong request was performed"
          end
        end
      end
    end
  end
end