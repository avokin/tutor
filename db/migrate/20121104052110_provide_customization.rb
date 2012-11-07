class ProvideCustomization < ActiveRecord::Migration
  def change
    add_column :user_words, :type_id, :integer
    add_column :user_words, :custom_int_field1, :integer
    add_column :user_words, :custom_string_field1, :string
  end
end
