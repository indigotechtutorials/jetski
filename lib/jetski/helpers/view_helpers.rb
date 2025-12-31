module Jetski
  module Helpers
    module ViewHelpers
      # Expecting a relative path.
      def render(partial_path)
        path_to_file = File.join(Jetski.app_root, 'app/views', path_to_controller, "_#{partial_path}.html.erb")
        File.read(path_to_file)
      end
    end
  end
end