class CreateTrainings < ActiveRecord::Migration
  def change
    create_table :trainings do |t|
      t.integer :user_category_id
      t.integer :direction_id

      t.timestamps
    end
  end
end
