require_relative './jetski/version'
require_relative './jetski/base_controller'
require_relative './jetski/server'
require_relative './jetski/router/parser'
require_relative './jetski/router'
require "webrick"
require "json"
require "json"
require "ostruct"

module Jetski
  # Debug stage add constants here for debugging.
  extend self
  def app_root
    Dir.pwd
  end
end