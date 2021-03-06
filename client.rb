require 'data_uri'
require 'mime-types'
require 'curb'
require 'json'
require 'debugger'

# set this then run bundle exec ruby client.rb path/to/some/image.jpg
url = "http://localhost:9292/flip"

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

service_url = url.chomp("/") + "/service"

c = Curl::Easy.new(service_url) do |curl| 
  curl.headers["Content-Type"] = "application/json"
  curl.verbose = true
end

c.on_success do |easy|
  response = JSON.parse(easy.body_str)
  if err = response['meta']['error']
    puts "Error: #{err}"
    Kernel.exit 1
  end
  
  response_data = URI::Data.new(response['content']['data'])
  ext = File.extname(path)
  outpath = File.join(File.dirname(path), File.basename(path, ext) + "-out" + ext)
  bytes = nil;
  File.open(outpath ,'wb'){|f| bytes = f.write(response_data.data)}
  puts "Wrote #{bytes} bytes to #{outpath}."
end

c.post(payload)