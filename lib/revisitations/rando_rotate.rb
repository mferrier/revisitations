require 'revisitations/service'

class Revisitations::RandoRotate < Revisitations::Service
  def run
    begin
      content = {}
      meta = {}

      params = JSON.parse(@body)
      content = params.fetch("content", content)
      meta = params.fetch("meta", meta)
      data_uri = URI::Data.new(content['data']) 
      content_type = data_uri.content_type
      mime_type = MIME::Types[content_type].first
      extension = mime_type.extensions.last

      tmp = Tempfile.new(['rando', "." + extension])
      tmp.binmode
      tmp.write(data_uri.data)
      tmp.flush

      outdir = Dir.mktmpdir
      outpath = File.join(outdir, "out.#{extension}")
      deg = rand(0..359)

      log "Rotating #{tmp.path} by #{deg} deg"
      cmd = "convert -background none -rotate #{deg} #{tmp.path} #{outpath}"
      log cmd, :debug
      system cmd

      File.open(outpath) do |f|
        out_uri = URI::Data.build(:content_type => content_type, :data => f)
        content['data'] = out_uri.to_s
      end

      tmp.close
      FileUtils.rm_rf(outdir)

      JSON.dump({'content' => content, 'meta' => meta})
    rescue Exception => e
      meta['error'] = e.inspect
      JSON.dump({'content' => content, 'meta' => meta})
    end
  end
end

Revisitations::Service.register('rando-rotate', Revisitations::RandoRotate)