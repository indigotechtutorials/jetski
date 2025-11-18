require 'webrick'
require 'pry'
require_relative './splash_router'
require_relative './waterfall_controller.rb'

module Jetski
  class Server
    def initialize
    end

    def call
      server = WEBrick::HTTPServer.new Port: 8000

      Jetski::SplashRouter.new(server).call

      trap 'INT' do server.shutdown end

      server.start
    end
  end
end