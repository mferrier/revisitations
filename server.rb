require 'sinatra/base'
require 'sinatra/logger'

module RandoRotate
end

class RandoRotate::Server < Sinatra::Base
  register(Sinatra::Logger)
  set :logger_level, :info

  # logging
  before do
    logger.info "%s%s" % [request.host, request.path]
  end

  get '/' do
    'hello world'
  end
end