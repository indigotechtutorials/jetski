require 'bundler/setup'
require "jetski"

ENV['JETSKI_PROJECT_PATH'] = __dir__

Jetski::Server.new.call