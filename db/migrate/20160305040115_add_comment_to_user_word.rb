class AddCommentToUserWord < ActiveRecord::Migration
  def change
    add_column :user_words, :comment, :string
  end
end
