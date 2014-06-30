#config.ru
require 'rubygems'
require 'bundler'
Bundler.setup(:default)
require 'sinatra'
require './server.rb'

use Rack::Deflater
run JuliansSite
