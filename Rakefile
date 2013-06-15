#!/usr/bin/env rake

require File.expand_path('../nitwit_app', __FILE__)

namespace :assets do
  desc 'precompile assets'
  task :precompile => [:compile_js, :compile_css] do
  end

  desc 'compile javascript assets'
  task :compile_js do
    sprockets = NitwitApp.settings.sprockets
    asset     = sprockets['application.js']
    outpath   = File.join(NitwitApp.settings.assets_path, 'javascripts')
    outfile   = Pathname.new(outpath).join('application.js')

    FileUtils.mkdir_p outfile.dirname

    asset.write_to(outfile)
    asset.write_to("#{outfile}.gz")
  end

  desc 'compile css assets'
  task :compile_css do
    sprockets = NitwitApp.settings.sprockets
    asset     = sprockets['application.css']
    outpath   = File.join(NitwitApp.settings.assets_path, 'stylesheets')
    outfile   = Pathname.new(outpath).join('application.css')

    FileUtils.mkdir_p outfile.dirname

    asset.write_to(outfile)
    asset.write_to("#{outfile}.gz")
  end
end
