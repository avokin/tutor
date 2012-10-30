class RemovingWord < ActiveRecord::Migration
  def change
    UserWord.all.each do |uw|
      unless uw.word_id.nil?
        w = Word.find(uw.word_id)
        uw.update_attributes(:text => w.text, :language_id => w.language_id)
      end
    end
  end
end
