require 'sinatra'
require 'sass'
require "rubygems"

require 'builder'

require 'sinatra/assetpack'
require 'sinatra/activerecord'
require './environment'

require 'will_paginate'
require 'will_paginate/active_record'
require "will_paginate-bootstrap"

require 'nokogiri'

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

  def est_updated_at
    self.updated_at + Time.zone_offset('EST')
  end

  def trancated_body
    html_truncate(body, 200)
  end

  private

  def html_truncate(input, num_words = 15, truncate_string = "...")
    doc = Nokogiri::HTML(input)

    current = doc.children.first
    count = 0

    while true
      # we found a text node
      if current.is_a?(Nokogiri::XML::Text)
        count += current.text.split.length
        # we reached our limit, let's get outta here!
        break if count > num_words
        previous = current
      end

      if current.children.length > 0
        # this node has children, can't be a text node,
        # lets descend and look for text nodes
        current = current.children.first
      elsif !current.next.nil?
        #this has no children, but has a sibling, let's check it out
        current = current.next
      else
        # we are the last child, we need to ascend until we are
        # either done or find a sibling to continue on to
        n = current
        while !n.is_a?(Nokogiri::HTML::Document) and n.parent.next.nil?
          n = n.parent
        end

        # we've reached the top and found no more text nodes, break
        if n.is_a?(Nokogiri::HTML::Document)
          break;
        else
          current = n.parent.next
        end
      end
    end

    if count >= num_words
      unless count == num_words
        new_content = current.text.split

        # If we're here, the last text node we counted eclipsed the number of words
        # that we want, so we need to cut down on words.  The easiest way to think about
        # this is that without this node we'd have fewer words than the limit, so all
        # the previous words plus a limited number of words from this node are needed.
        # We simply need to figure out how many words are needed and grab that many.
        # Then we need to -subtract- an index, because the first word would be index zero.

        # For example, given:
        # <p>Testing this HTML truncater.</p><p>To see if its working.</p>
        # Let's say I want 6 words.  The correct returned string would be:
        # <p>Testing this HTML truncater.</p><p>To see...</p>
        # All the words in both paragraphs = 9
        # The last paragraph is the one that breaks the limit.  How many words would we
        # have without it? 4.  But we want up to 6, so we might as well get that many.
        # 6 - 4 = 2, so we get 2 words from this node, but words #1-2 are indices #0-1, so
        # we subtract 1.  If this gives us -1, we want nothing from this node. So go back to
        # the previous node instead.
        index = num_words-(count-new_content.length)-1
        if index >= 0
          new_content = new_content[0..index]
          current.content = new_content.join(' ') + truncate_string
        else
          current = previous
          current.content = current.content + truncate_string
        end
      end

      # remove everything else
      while !current.is_a?(Nokogiri::HTML::Document)
        while !current.next.nil?
          current.next.remove
        end
        current = current.parent
      end
    end

    # now we grab the html and not the text.
    # we do first because nokogiri adds html and body tags
    # which we don't want
    doc.root.children.first.inner_html
  end

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

  get '/rss' do
    @posts = Post.all.order("created_at desc").limit(5)
    builder :"posts/feed"
  end

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
