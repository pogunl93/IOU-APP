class CreateIou < ActiveRecord::Migration
  def up
  	create_table :ious do |i|
  		i.integer :owner_id
  		i.integer :debtor_id
  		i.integer :amount
  		i.integer :due_date
  	end 
  end

  def down
  	drop_table :ious
  end
end
