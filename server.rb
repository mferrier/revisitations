require 'sinatra/base'
require 'sinatra/logger'

module RandoRotate
end

class RandoRotate::Server < Sinatra::Base
  ROOT_PATH = File.expand_path(File.dirname(__FILE__))
  set :root, ROOT_PATH

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