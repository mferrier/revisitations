require 'revisitations/service'

# Example service that rotates the incoming file by a random amount
class Revisitations::Example < Revisitations::Service
  def run
    tmp = Tempfile.new(['foo', "." + extension])
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
  end
end

Revisitations::Service.register('example', Revisitations::Example)
