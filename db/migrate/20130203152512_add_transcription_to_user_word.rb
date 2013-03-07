class AddTranscriptionToUserWord < ActiveRecord::Migration
  def change
    add_column :user_words, :transcription, :string
  end
end
