require "webrick"
require "json"
require "json"
require "ostruct"
require "erb"

require_relative './jetski/version'
require_relative './jetski/base_controller'
require_relative './jetski/server'
require_relative './jetski/router/parser'
require_relative './jetski/router'

module Jetski
  extend self
  def app_root
    Dir.pwd
  end
end