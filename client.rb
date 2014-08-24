require 'data_uri'
require 'mime-types'
require 'curb'
require 'json'
require 'debugger'

# url = "http://revisit-rando-rotate.dev:3000/service"
url = "http://revisit-rando-rotate.herokuapp.com/service"
# url = "http://hiiamchris.com:4200/service"

path = ARGV.first

if !path
  puts "bundle exec ruby #{__FILE__} <path to image>"
  Kernel.exit
end

path = File.expand_path(path)

file = File.open(path, 'rb')
mime_type = MIME::Types.type_for(path).first
data_uri = URI::Data.build(:content_type => mime_type.content_type, :data => file)
payload = JSON.dump({:content => {:data => data_uri.to_s}, :meta => {}})

c = Curl::Easy.new(url) do |curl| 
  curl.headers["Content-Type"] = "application/json"
  curl.verbose = true
end

c.on_success do |easy|
  response = JSON.parse(easy.body_str)
  response_data = URI::Data.new(response['content']['data'])
  ext = File.extname(path)
  outpath = File.join(File.dirname(path), File.basename(path, ext) + "-out" + ext)
  bytes = nil;
  File.open(outpath ,'wb'){|f| bytes = f.write(response_data.data)}
  puts "Wrote #{bytes} bytes to #{outpath}."
end

c.post(payload)