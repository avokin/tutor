class AddUserIdToTrainings < ActiveRecord::Migration
  def change
    add_column :trainings, :user_id, :integer
    change_column :trainings, :user_id, :integer, :null => false
  end
end
