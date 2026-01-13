require "webrick"
require "json"
require "ostruct"
require "erb"
require "rack"
require "sqlite3"

require_relative './jetski/version'
require_relative './jetski/helpers/generic'
require_relative './jetski/helpers/view_helpers'
require_relative './jetski/helpers/route_helpers'
require_relative './jetski/helpers/delegatable'
require_relative './jetski/frontend/javascript_helpers'
require_relative './jetski/base_controller'
require_relative './jetski/router/file_path_helper'
require_relative './jetski/router/parser'
require_relative './jetski/router/host/base'
require_relative './jetski/router/host/controller'
require_relative './jetski/router/host/crud'
require_relative './jetski/router'
require_relative './jetski/autoloader'
require_relative './jetski/server'
require_relative './jetski/database/base'
require_relative './jetski/database/sqlite3'
require_relative './jetski/model/crud_helpers'
require_relative './jetski/model'
require_relative './jetski/view_renderer'

class Jetski
  include Jetski::Helpers::Generic
  def self.app_root
    Dir.pwd
  end
end