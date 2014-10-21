require 'sinatra'

module Koyabu
  class Server < Sinatra::Base
    configure do
      enable :logging
      file = File.new("#{settings.root}/log/#{settings.environment}.log", 'a+')
      file.sync = true
      use Rack::CommonLogger, file
    end

    register Sinatra::Gyazo

    get '/' do
      'Hello World'
    end
  end
end
