#!/system/bin/env ruby
require 'webrick'

class NonCachingFileHandler < WEBrick::HTTPServlet::FileHandler
  def prevent_caching(res)
    res['ETag']          = nil
    res['Last-Modified'] = Time.now + 100**4
    res['Cache-Control'] = 'no-store, no-cache, must-revalidate, post-check=0, pre-check=0'
    res['Pragma']        = 'no-cache'
    res['Expires']       = Time.now - 100**4
  end
  
  def do_GET(req, res)
    super
    prevent_caching(res)
  end
end

class WhiteCastle
  def self.start(options)

    default_options = {:port => 80, :document_root => "."}
    options         = default_options.merge(options)
    
    server = WEBrick::HTTPServer.new(
      :Port           => options[:port],
      :DocumentRoot   => options[:document_root],
      :FancyIndexing  =>    true
    )
    server.mount '/nocache', NonCachingFileHandler
    trap('INT') { server.stop }
    server.start
  end
end

args = ARGV.compact
p = args[0]? args[0] : Dir.pwd
WhiteCastle.start(:document_root => p)

