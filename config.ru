require 'rubygems'
require 'bundler'

Bundler.require

require './server'

map '/' do
  run RandoRotate::Server
end
