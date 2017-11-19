class AddRequestCountToUserWord < ActiveRecord::Migration
  def change
    add_column :user_words, :request_count, :integer, :default => 0
  end
end
