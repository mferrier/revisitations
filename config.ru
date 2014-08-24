require 'rubygems'
require 'bundler'

Bundler.require

require './server'

map '/' do
  run Revisitations::Server
end
