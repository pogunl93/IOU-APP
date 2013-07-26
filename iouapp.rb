require 'rubygems'
require 'haml'
require 'sinatra'
require 'sinatra/activerecord'
require 'stringio'
configure(:development){ set :database, "sqlite3:///Twitter_DB.sqlite3" }
require './models'
require 'bundler/setup'
require 'sinatra/base'
require 'rack-flash'
require './models'
require './helpers'
require 'bcrypt'
require 'pony'
require 'mandrill'

enable :sessions 
use Rack::Flash, :sweep => true 

set :sessions => true 

get '/' do 
	haml :home
end 

get '/profile' do
	haml :profile
end

get '/sign_up' do
	haml :sign_up
end 

post '/sign_up' do
	User.create(:fname => params[:fname], :lname => params[:lname], :email => params[:email], :password_hash => params[:password])
		m = Mandrill::API.new
		message = {
		 :subject=> "Hello from the Mandrill API",
		 :from_name=> "Paulo",
		 :text=>"Hi message, how are you?",
		 :to=>[
		   {
		     :email=> params[:email],
		     :name=> params[:fname]
		   }
		 ],
		 :html=>"<html><h1>Hi <strong>message</strong>, how are you?</h1></html>",
		 :from_email=>"ogunlowo.p@gmail.com"
		}
		sending = m.messages.send message
	redirect '/'
end 

get '/sign_in' do 
	haml :sign_in
end 

post '/sign_in' do 
	@user = User.where(:email => params[:email].downcase).first
	if @user 
		if @user.password_hash == params[:password]
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

get '/new_iou' do
	haml :new_iou
end 

post '/new_iou' do
	@user = User.where(:email => params[:debtor_email]).first
	if @user 
		Iou.create(:owner_id => current_user.id, :debtor_id => @user.id, :amount => params[:amount_owed], :due_date => params[:date_due])
		flash[:notice] = "#{@user.fname} will be notified of this $#{params[:amount_owed]} IOU"
	else 
		flash[:notice] = "This user does not exist"
		redirect '/new_iou'
	end
	redirect '/'
end

get '/your_money/:id' do 
	@user = User.find(params[:id])
	if current_user == @user
		@iou_owe = Iou.where(:debtor_id => params[:id].to_i)
		@iou_owed = Iou.where(:owner_id => params[:id].to_i)
		haml :your_money 
	else 
		redirect '/'
	end
end

