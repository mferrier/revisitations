module Revisitations
end

Dir.glob(File.join(File.expand_path("..", __FILE__), 'revisitations', '*.rb')).each do |path|
  require "revisitations/#{File.basename(path, '.rb')}"
end