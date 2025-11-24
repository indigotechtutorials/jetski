module Jetski
  class Server
    def initialize
    end

    def call
      server = WEBrick::HTTPServer.new Port: 8000

      Jetski::Router.new(server).call

      trap 'INT' do server.shutdown end

      server.start
    end
  end
end