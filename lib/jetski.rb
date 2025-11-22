require_relative './jetski/server'
require_relative './jetski/splash_router'
require_relative './jetski/waterfall_controller'
require "webrick"
require "pry"

module Jetski
  APP_ROOT = Dir.pwd
end