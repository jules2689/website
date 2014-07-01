require 'sinatra'
require 'sass'
require "rubygems"

require 'sinatra/assetpack'
require 'sinatra/activerecord'
require 'sinatra/google-auth'
require './environment'

class Post < ActiveRecord::Base
  validates_presence_of :title, :body
  before_validation :set_handle
  private
  def set_handle
    self.handle = self.title.downcase.parameterize
  end
end

class JuliansSite < Sinatra::Base
  register Sinatra::AssetPack
  register Sinatra::GoogleAuth
  use Rack::MethodOverride

  set :root, File.dirname(__FILE__)

  assets {
    css :app , ['/css/*.css']
    js :app , ['/js/**/*.js']
  }
  set :public_folder, 'public'

  get '/' do
    erb :index
  end

  # Posts

  get "/posts" do
    @posts = Post.all
    erb :"posts/index"
  end

  get "/posts/new" do
    authenticate
    @title = "New Post"
    @post = Post.new
    erb :"posts/new"
  end

  post "/posts" do
    authenticate
    @post = Post.new(params[:post])
    if @post.save
      redirect "posts/#{@post.handle}"
    else
      erb :"posts/new"
    end
  end

  get "/posts/:handle" do
    @post = Post.find_by(handle: params[:handle])
    @title = @post.title
    erb :"posts/show"
  end

  get "/posts/:handle/edit" do
    authenticate
    @post = Post.find_by(handle: params[:handle])
    @title = "Edit Form"
    erb :"posts/edit"
  end

  put "/posts/:handle" do
    authenticate
    @post = Post.find_by(handle: params[:handle])
    if @post.update_attributes(params[:post])
      redirect "/posts/#{@post.handle}"
    else
      erb :"posts/edit"
    end
  end

  delete "/posts/:id" do
    authenticate
    @post = Post.find(params[:id]).destroy
    redirect "/posts"
  end

  get '/logout' do
    session["user"] = nil
    redirect "/"
  end

end
