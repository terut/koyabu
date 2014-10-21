require 'sinatra'

module Koyabu
  class Server < Sinatra::Base
    register Sinatra::Gyazo

    get '/' do
      'Hello World'
    end
  end
end
