require 'sinatra'
require 'sass'
require 'sinatra/assetpack'
require "rubygems"

class JuliansSite < Sinatra::Base
  register Sinatra::AssetPack

  set :root, File.dirname(__FILE__)

  assets {
    css :app , ['/css/*.css']
    js :app , ['/js/**/*.js']
  }
  set :public_folder, 'public'

  get '/' do
    erb :index
  end

end
