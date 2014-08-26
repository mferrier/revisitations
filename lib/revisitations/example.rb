require 'revisitations/service'

# Example service that rotates the incoming file by a random amount.
#
# Requires the Imagemagick buildpack (see README.md)
class Revisitations::Example < Revisitations::Service
  def run
    # write the incoming file to the filesystem
    tmp = Tempfile.new(['foo', "." + extension])
    tmp.binmode
    tmp.write(data_uri.data)
    tmp.flush

    # figure out where to put the output
    outdir = Dir.mktmpdir
    outpath = File.join(outdir, "out.#{extension}")

    # process
    deg = rand(0..359)
    log "Rotating #{tmp.path} by #{deg} deg"
    cmd = "convert -background none -rotate #{deg} #{tmp.path} #{outpath}"
    log cmd, :debug
    system cmd

    # read the output into a new data-uri
    File.open(outpath) do |f|
      out_uri = URI::Data.build(:content_type => content_type, :data => f)
      # set the output as the data that gets returned by the service
      content['data'] = out_uri.to_s
    end

    # cleanup
    tmp.close
    FileUtils.rm_rf(outdir)
  end
end

Revisitations::Service.register('example', Revisitations::Example)
