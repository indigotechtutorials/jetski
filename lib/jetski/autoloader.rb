module Jetski
  module Autoloader
    include Jetski::Router::SharedMethods
    extend self
    # Responsibility is to load all models in app.
    def call
      model_file_paths.each do |path_to_model|
        require_relative path_to_model
        # Call method to define model attributes after loading
        model_name = path_to_model.split("app/models/")[-1]
          .gsub(".rb", "")
          .split("/")
          .map(&:capitalize)
          .join("::")
        # posts/comment
        # Post/comment
        model_class = Object.const_get(model_name)
        model_class.define_attribute_methods
      end
    end

    def load_controllers
      controller_file_paths.each do |file_path|
        require_relative file_path
      end
    end
  end
end