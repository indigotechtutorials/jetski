require_relative './jetski/server'
require_relative './jetski/splash_router'
require_relative './jetski/waterfall_controller'
require "webrick"
require "pry"

module Jetski
  APP_ROOT = if defined?(Bundler)
             Bundler.root
           else
             Dir.pwd
           end
end