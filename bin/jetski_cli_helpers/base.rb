# Reason for this is to dry up code and includes between classes
module JetskiCLIHelpers
  class Base < Thor
    include Jetski::Helpers::Generic, Thor::Actions, JetskiCLIHelpers::SharedMethods,
      Jetski::Database::Base
  end
end