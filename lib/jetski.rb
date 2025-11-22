require_relative './jetski/server'
require_relative './jetski/splash_router'
require_relative './jetski/waterfall_controller'
require "webrick"
require "pry"

module Jetski
  # Debug stage add constants here for debugging.
  extend self
  def app_root
    if ENV['JETSKI_PROJECT_PATH']
      ENV['JETSKI_PROJECT_PATH']
    elsif ENV['USE_DIR']
      __dir__
    else
      Dir.pwd
    end
  end
end