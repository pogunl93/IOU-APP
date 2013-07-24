require 'rubygems'
require 'haml'
require 'sinatra'
require 'sinatra/activerecord'
require 'scoped_search'
require 'stringio'
configure(:development){ set :database, "sqlite3:///Twitter_DB.sqlite3" }
require './models'
require 'carrierwave'
require 'carrierwave/orm/activerecord'
require 'bundler/setup'
require 'sinatra/base'
require 'rack-flash'
require './models'
require './helpers'

enable :sessions 
use Rack::Flash, :sweep => true 

set :sessions => true 

get '/' do 
	haml :home
end 

get '/sign_up' do
	haml :sign_up
end 

post '/sign_up' do
	if params[:password] == params[:confirm_password]
		User.create(:fname => params[:fname], :lname => params[:lname], :email => params[:email], :password => params[:password])
	else 
		flash[:notice] = "Your passwords do not match"
	end 
	redirect '/sign_up'
end 

get '/sign_in' do 
	haml :sign_in
end 

post '/sign_in' do 
	@user = User.where(:email => params[:email]).first
	if @user 
		if @user.password == params[:password]
			session[:user_id] = @user.id
			flash[:notice] = "Welcome back, #{@user.fname}"
			redirect '/'
		else 
			flash[:notice] = "Your password was wrong, please try again"
			redirect '/sign_in'
		end 
	else 
		flash[:notice] = "Your username was not found"
		redirect '/sign_in'
	end 
end

get '/sign_out' do 
	session[:user_id] = nil
	redirect '/'
end 