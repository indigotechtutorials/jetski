module Jetski
  module Autoloader
    include Jetski::Router::SharedMethods
    extend self
    # Responsibility is to load all models in app.
    def call
      model_file_paths.each do |path_to_model|
        require_relative path_to_model
      end
    end

    def load_controllers
      controller_file_paths.each do |file_path|
        require_relative file_path
      end
    end
  end
end