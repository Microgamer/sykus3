require 'bundler'
Bundler.setup :default

require 'thin'
require 'sinatra'

basedir = File.join(File.dirname(__FILE__), 'dist_debug')

set :bind, '0.0.0.0'
set :port, 4242

get %r{.*} do
  file = File.join(basedir, request.path_info)

  [ file, "#{file}.html", "#{file}/index.html" ].each do |f|
    return send_file f if File.file? f
  end

  [ 404, 'Not found' ]
end


