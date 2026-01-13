# Reason for this is to dry up code and includes between classes
module JetskiCLIHelpers
  class Base < Thor
    include Jetski::Helpers::Generic, Thor::Actions, JetskiCLIHelpers::SharedMethods,
      Jetski::Database::Base
    
    def self.source_root
      File.join(File.dirname(__FILE__), '..', '..', 'templates')
    end
  end
end