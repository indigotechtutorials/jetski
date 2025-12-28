module Jetski
  class Server
    attr_reader :port
    
    def initialize(**args)
      @port = args[:port] || 8000
    end

    def call
      server = WEBrick::HTTPServer.new Port: port

      Jetski::Autoloader.call
      
      Jetski::Router.new(server).call

      trap 'INT' do server.shutdown end

      server.start
    end
  end
end