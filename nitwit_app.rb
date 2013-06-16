$:.unshift(File.expand_path('../lib', __FILE__))
require 'nitwit'

require 'bundler'
Bundler.require

class NitwitApp < Sinatra::Base
  set :assets_precompile, %w{ application.js application.css *.png *.jpg *.jpeg *.gif }
  set :assets_css_compressor, :sass
  set :assets_js_compressor, :uglifier
  register Sinatra::AssetPipeline

  configure do
    %w{javascripts stylesheets images}.each do |type|
      sprockets.append_path "assets/#{type}"
      sprockets.append_path Compass::Frameworks['bootstrap'].templates_directory + "/../vendor/assets/#{type}"
    end
    sprockets.append_path 'assets/font'
  end

  Sprockets::Helpers.configure do |config|
    config.environment = sprockets
    config.prefix      = assets_prefix
    config.public_path = public_folder
  end

  helpers do
    include Nitwit::Helpers
  end

  before do
    session[:oauth] ||= {}
  end

  get '/' do
    erb :index, layout: :'layouts/application'
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

  get '/search' do
  end

  get '/logout' do
    session[:oauth] = {}
    redirect to('/')
  end

end
