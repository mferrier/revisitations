$: << '.'
require 'server'
map '/' do
  run RandoRotate::Server
end
