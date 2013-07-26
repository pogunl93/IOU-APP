class User < ActiveRecord::Base
	
	def full_name 
		fname+ " " +lname
	end 

	has_many :debits_as_user, :foreign_key => :debtor_id, :class_name => "Iou"
	has_many :debits, :through => :debits_as_user

	has_many :credits_as_user, :foreign_key => :owner_id, :class_name => "Iou"
	has_many :credits, :through => :credits_as_user

	def send_iou_email(receiver, iou)
		m = Mandrill::API.new
		message = {
		 :subject=> "Hello from the Mandrill API",
		 :from_name=> "Your name",
		 :text=>"Hi message, how are you?",
		 :to=>[
		   {
		     :email=> "recipient@theirdomain.com",
		     :name=> "Recipient1"
		   }
		 ],
		 :html=>"<html><h1>Hi <strong>message</strong>, how are you?</h1></html>",
		 :from_email=>"sender@yourdomain.com"
		}
		sending = m.messages.send message
		puts sending
	end 

	def encrypt_password
	  if self.password.present?
	    self.password_salt = BCrypt::Engine.generate_salt
	    self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
	  end
	end

	def self.authenticate(email, password)
    user = User.where(:email => email).first
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
	end

end 

class Iou < ActiveRecord::Base

	belongs_to :debitor, :foreign_key => :debtor_id, :class_name => "User"

	belongs_to :creditor, :foreign_key => :owner_id, :class_name => "User"
end 