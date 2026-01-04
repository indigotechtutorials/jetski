module JetskiCLIHelpers
  class Destroy < Thor
    include Thor::Actions, JetskiCLIHelpers::Destroyers::Controller,
    JetskiCLIHelpers::Destroyers::Model
    desc "controller NAME ACTION_NAMES", "Destroys a controller"
    def controller(name, *actions)
      destroy_controller(name)
    end

    desc "model NAME ACTION_NAMES", "Destroys a model"
    def model(name, *actions)
      destroy_model(name)
    end
  end
end