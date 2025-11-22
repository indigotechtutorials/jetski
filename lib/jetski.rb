require_relative './jetski/server'
require_relative './jetski/splash_router'
require_relative './jetski/waterfall_controller'
require "webrick"
require "pry"

module Jetski
  # TODO: Fix this so its dynamic user can set path to app root dynamically..
  APP_ROOT = Dir.pwd
end