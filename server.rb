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

  MAX_DATA_LENGTH = 1024*1024

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
      begin
        service = Revisitations::Service[service_name].new(request.body.read)
        service.run()
      rescue Exception => e
        service.set_error(e)
      end
      
      if service.content['data'].length > MAX_DATA_LENGTH
        service.set_error "Output data length exceeds max"
      end

      JSON.dump({'content' => service.content, 'meta' => service.meta})
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