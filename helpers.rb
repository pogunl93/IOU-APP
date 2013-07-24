helpers do 
	def current_user
		session[:user_id].nil? ? nil : User.find(session[:user_id])
	end 
end 