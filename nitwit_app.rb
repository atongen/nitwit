$:.unshift(File.expand_path('../lib', __FILE__))
require 'nitwit'

require 'bundler'
Bundler.require

class NitwitApp < Sinatra::Base
  set :root,          File.dirname(__FILE__)
  set :assets,        Sprockets::Environment.new(root)
  set :precompile,    [ /\w+\.(?!js|css).+/, /application.(css|js)$/ ]
  set :assets_prefix, '/assets'
  set :digest_assets, false
  set(:assets_path)   { File.join public_folder, assets_prefix }
  set :static_cache_control, [:public, max_age: 60 * 60 * 24 * 365]

  configure do
    # Setup Sprockets
    %w{javascripts stylesheets images}.each do |type|
      assets.append_path "assets/#{type}"
      assets.append_path Compass::Frameworks['bootstrap'].templates_directory + "/../vendor/assets/#{type}"
    end
    assets.append_path 'assets/font'

    # Configure Sprockets::Helpers (if necessary)
    Sprockets::Helpers.configure do |config|
      config.environment = assets
      config.prefix      = assets_prefix
      config.digest      = digest_assets
      config.public_path = public_folder
    end
    Sprockets::Sass.add_sass_functions = false

    set :haml, { :format => :html5 }
  end

  helpers do
    include Sinatra::JSON
    include Sprockets::Helpers
    include Nitwit::Helpers
  end

  before do
    session[:oauth] ||= {}
  end

  get '/' do
    haml :index, layout: :'layouts/application'
  end

  get '/login' do
    @request_token = consumer.get_request_token(oauth_callback: "#{my_url}/auth")
    session[:oauth][:request_token] = @request_token.token
    session[:oauth][:request_token_secret] = @request_token.secret
    redirect to(@request_token.authorize_url)
  end

  get '/auth' do
    @access_token = request_token.get_access_token(oauth_verifier: params[:oauth_verifier])
    session[:oauth][:access_token] = @access_token.token
    session[:oauth][:access_token_secret] = @access_token.secret
    redirect to('/')
  end

  get '/search.json' do
    json Nitwit::SearchService.search(params)
  end

  get '/logout' do
    session[:oauth] = {}
    redirect to('/')
  end

end
