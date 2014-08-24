require 'sinatra/base'
require 'json'
require 'data_uri'
require 'active_support/core_ext/string'
require 'logger'
require 'tempfile'
require 'mime-types'
require 'fileutils'

require 'sinatra/reloader' if development?
require 'debugger' if development?

$:.unshift File.expand_path('./lib')
require 'revisitations'

class Revisitations::Server < Sinatra::Base
  ROOT_PATH = File.expand_path(File.dirname(__FILE__))
  set :root, ROOT_PATH

  LOG = Logger.new(STDOUT)

  configure :development do
    register Sinatra::Reloader
    LOG.level = Logger::DEBUG
  end

  configure :production do
    LOG.level = Logger::INFO
  end

  get "/" do
    pong()
  end

  Revisitations::Service.names.each do |service_name|
    get "/#{service_name}" do
      pong()
    end

    post "/#{service_name}/service" do
      service = Revisitations::Service[service_name].new(request.body.read)
      service.run()
    end
  end

  helpers do
    def log(msg, level = :info)
      Revisitations::Server.log(msg, level)
    end

    def pong
      "PONG!"
    end    
  end

  def self.log(msg, level = :info)
    LOG.send(level, msg.to_s)
  end
end