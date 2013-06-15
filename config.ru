require File.expand_path('../nitwit_app', __FILE__)

unless ENV['RACK_ENV'] == 'development'
  use Rack::Cache, verbose: false
end

use Rack::Session::Cookie, :key => 'nitwit.session',
                           :expire_after => 31536000, # one year
                           :secret => ENV['SESSION_SECRET']

map NitwitApp.assets_prefix do
  run NitwitApp.assets
end

map '/' do
  run NitwitApp
end