class Revisitations::Service
  SERVICES = {}
  MAX_DATA_LENGTH = 1024*1024

  class << self
    def register(name, klass)
      SERVICES[name] = klass
    end

    def names
      SERVICES.keys
    end

    def [](service_name)
      SERVICES[service_name]
    end
  end

  attr_reader :content, :meta, :data_uri, :content_type, :mime_type, :extension

  def initialize(body)
    @content = {}
    @meta = {}

    params = JSON.parse(body)
    @content = params.fetch("content", @content)
    @meta = params.fetch("meta", @meta)
    
    # keep a copy so that if something goes wrong and we just want to pass the
    # original request back
    @original_data = @content['data']

    # URI::Data object of the incoming data. Use data_uri.data for the binary data.
    @data_uri = URI::Data.new(@original_data) 
    @content_type = @data_uri.content_type
    @mime_type = MIME::Types[@content_type].first
    @extension = @mime_type.extensions.last
  end

  def run
    # code goes here
  end

  def log(msg, level = :info)
    Revisitations::Server.log(msg, level)
  end

  # Handle an error by setting an error in the meta of the response and revert
  # the data back to whatever was originally posted (don't break da chain)
  def set_error(e)
    meta['error'] = e.inspect
    @content['data'] = @original_data
  end
end