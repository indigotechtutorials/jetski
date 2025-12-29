module Jetski
  module Helpers
    module ViewHelpers
      def render(path_to_file)
        File.join(Jetski.app_root, path_to_file)
      end
    end
  end
end