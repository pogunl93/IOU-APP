helpers do 
	def current_user
		session[:user_id].nil? ? nil : User.find(session[:user_id])
	end 

  def totals(ious)
    total = 0
    ious.each do |iou|
      total = total + iou.amount
    end
    total
  end
end 