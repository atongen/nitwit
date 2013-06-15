require File.expand_path('../nitwit_app', __FILE__)

use Rack::Session::Cookie, :key => 'nitwit.session',
                           :expire_after => 31536000, # one year
                           :secret => ENV['SESSION_SECRET']

map NitwitApp.assets_prefix do
  run NitwitApp.assets
end

map '/' do
  run NitwitApp
end
