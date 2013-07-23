class CreateUsers < ActiveRecord::Migration
  def up
  	create_table :users do |u|
  		u.string :fname 
  		u.string :lname
  		u.string :email
  	end
  end

  def down
  	drop_table :users
  end
end
