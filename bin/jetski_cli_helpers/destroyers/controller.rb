module JetskiCLIHelpers
  module Destroyers
    module Controller
      def destroy_controller(name)
        pluralized_name = if name[-1] == 's'
          name
        else
          name + 's'
        end

        controller_file_path = "app/controllers/#{pluralized_name}_controller.rb"
        remove_file(controller_file_path)
        view_folder = "app/views/#{pluralized_name}"
        remove_dir(view_folder)
      end
    end
  end
end