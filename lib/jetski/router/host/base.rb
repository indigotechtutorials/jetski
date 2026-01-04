module Jetski
  class Router
    module Host
      class Base
        attr_reader :server, :errors, :served_url, :request_method, :req, :res,
          :controller_classname, :controller_file_name, :controller_path, 
          :controller_name, :action_name, :controller_class, :all_server_options
        
        attr_writer :res, :req
        
        def initialize(server, **server_options)
          @server = server
          @errors = []
          @all_server_options = server_options
          @served_url = server_options[:url]
          @request_method = server_options[:method]
          @controller_file_name = server_options[:controller_file_name]
          @controller_path = server_options[:controller_path]
          @controller_classname = server_options[:controller_classname]
          @controller_name = server_options[:controller_name]
          @action_name = server_options[:action_name]
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
          if request_method && (request_method != req.request_method)
            @errors << "Wrong request was performed"
          end
        end
      end
    end
  end
end