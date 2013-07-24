require 'rubygems'
require 'haml'
require 'sinatra'
require 'sinatra/activerecord'
require 'scoped_search'
require 'stringio'
configure(:development){ set :database, "sqlite3:///Twitter_DB.sqlite3" }
#require './models'
require 'carrierwave'
require 'carrierwave/orm/activerecord'
require 'bundler/setup'
require 'sinatra/base'
require 'rack-flash'
require './models'

get '/' do 
	haml :home
end 