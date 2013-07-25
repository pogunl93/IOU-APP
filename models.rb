class User < ActiveRecord::Base
	
	def full_name 
		fname+ " " +lname
	end 

	has_many :debits_as_user, :foreign_key => :debtor_id, :class_name => "Iou"
	has_many :debits, :through => :debits_as_user

	has_many :credits_as_user, :foreign_key => :owner_id, :class_name => "Iou"
	has_many :credits, :through => :credits_as_user

	#has_many :credits, :foreign_key => :owner_id
end 

class Iou < ActiveRecord::Base

	belongs_to :debitor, :foreign_key => :debtor_id, :class_name => "User"

	belongs_to :creditor, :foreign_key => :owner_id, :class_name => "User"
end 