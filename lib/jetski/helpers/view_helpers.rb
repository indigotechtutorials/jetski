module Jetski
  module Helpers
    module ViewHelpers
      # Expecting a relative path.
      def render(partial_path, **locals)
        path_to_file = File.join(Jetski.app_root, 'app/views', path_to_controller, "_#{partial_path}.html.erb")
        content = File.read(path_to_file)
        bind = binding
        locals.each do |k, v| 
          bind.local_variable_set k, v
        end
        template = ERB.new(content)
        template.result(bind)
      end
    end
  end
end