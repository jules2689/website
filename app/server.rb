require 'sinatra'
require 'sass'
require "rubygems"

require 'sinatra/assetpack'
require 'sinatra/activerecord'
require './environment'

require 'will_paginate'
require 'will_paginate/active_record'
require "will_paginate-bootstrap"

require 'oauth2'
require 'json'

class Post < ActiveRecord::Base
  default_scope { order(updated_at: :desc) }
  validates_presence_of :title, :body
  before_validation :set_handle

  def list_tags
    self.tags ? "Tagged #{self.tags} / " : ""
  end

  def est_created_at
    self.created_at + Time.zone_offset('EST')
  end

  private
  def set_handle
    self.handle = self.title.downcase.parameterize
  end
end

class JuliansSite < Sinatra::Base
  include WillPaginate::Sinatra::Helpers
  register Sinatra::AssetPack
  use Rack::MethodOverride

  set :root, File.dirname(__FILE__)

  enable :sessions

  assets {
    css :app , ['/css/*.css']
    js :app , ['/js/**/*.js']
  }
  set :public_folder, 'public'

  get '/' do
    erb :index
  end

  # ============= Posts =============

  get "/posts" do
    @posts = Post.paginate(:page => params[:page], :per_page => 10)
    erb :"posts/index"
  end

  get "/posts/new" do
    authenticate
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
    erb :"posts/show"
  end

  get "/posts/:handle/edit" do
    authenticate
    @post = Post.find_by(handle: params[:handle])
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

  # ============= Authentication =============

  get '/logout' do
    session["access_token"] = nil
    redirect "/"
  end

  get "/auth" do
    redirect client.auth_code.authorize_url(:redirect_uri => redirect_uri, :scope => 'https://www.googleapis.com/auth/userinfo.email', :access_type => "offline", :hd => "jnadeau.ca")
  end

  get '/oauth2callback' do
    access_token = client.auth_code.get_token(params[:code], :redirect_uri => redirect_uri)
    session["access_token"] = access_token.token
    redirect "/posts"
  end

  def redirect_uri
    uri = URI.parse(request.url)
    uri.path = '/oauth2callback'
    uri.query = nil
    uri.to_s
  end

  def client
    client ||= OAuth2::Client.new(ENV['G_API_CLIENT'], ENV['G_API_SECRET'], {
                  :site => 'https://accounts.google.com',
                  :authorize_url => "/o/oauth2/auth",
                  :token_url => "/o/oauth2/token"
                })
  end

  def authenticate
    redirect "/" if session["access_token"].nil?
  end

end
