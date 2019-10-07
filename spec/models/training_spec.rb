require 'spec_helper'

describe Training do
  before(:each) do
    init_db
  end

  describe 'creation of Training object' do
    before(:each) do
      @user = FactoryBot.create(:user)
      @attr = {:direction => :direct}
      @user_category = FactoryBot.create(:user_category)
      @another_user = FactoryBot.create(:user)
    end

    it 'should not create a new instance without user-category' do
      training = Training.new @attr
      training.user = @user
      expect(training.valid?).to be false
    end

    it 'should create a new instance with user-category' do
      training = Training.new @attr.merge(:user_category => @user_category)
      training.user = @user
      training.save!
      expect(training.user_category).to eq @user_category
    end

    it 'should not bind category of another user' do
      training = Training.new @attr.merge(:user_category => @user_category)
      training.user = @another_user
      expect(training).not_to be_valid
    end

    it 'should validate uniqueness of user_category_id and direction' do
      training1 = Training.new @attr.merge(:user_category => @user_category)
      training1.user = @user
      training1.save!

      training2 = Training.new @attr.merge(:user_category => @user_category)
      training2.user = @user
      expect(training2).not_to be_valid
    end
  end

  describe 'find_by_user' do
    before(:each) do
      @training = FactoryBot.create(:training)
      @another_user = FactoryBot.create(:user)
      @user_category = FactoryBot.create(:user_category, :user => @another_user)
      @training_of_another_user = FactoryBot.create(:training, :user_category => @user_category, :user => @another_user)
    end

    it 'should find all Training object for user' do
      @trainings = Training.where user_id: @training.user.id
      expect(@trainings.length).to eq 1
      expect(@trainings.first).to eq @training
    end
  end

  describe 'get_ready_user_words' do
    before(:each) do
      @training = FactoryBot.create(:training)
      @english_words = Array.new
      (1..40).each do |i|
        if i % 2 == 0
          english_word = FactoryBot.create(:english_user_word, :time_to_check => DateTime.new(2021,2,3,4,5,6))
        else
          english_word = FactoryBot.create(:english_user_word)
        end

        FactoryBot.create(:word_relation_translation, :source_user_word => english_word)
        @english_words << english_word
        FactoryBot.create(:user_word_category, :user_word => english_word, :user_category => @training.user_category)
      end
    end

    it 'should return only ready words for the entire training' do
      @words_on_page_2 = UserWord.from_category_ready(@training.user_category)
      expect(@words_on_page_2.size).to eq 20
    end
  end

  describe 'get_user_words' do
    before(:each) do
      @training = FactoryBot.create(:training)
      @user_word = FactoryBot.create(:english_user_word, :time_to_check => DateTime.new(2021,2,3,4,5,6))
      FactoryBot.create(:user_word_category, :user_word => @user_word, :user_category => @training.user_category)


      FactoryBot.create(:user_word_category, :user_category => @training.user_category)

      FactoryBot.create(:word_relation_translation, :source_user_word => @user_word)
      FactoryBot.create(:word_relation_translation, :source_user_word => @user_word)
    end

    it 'should return corresponding words only once' do
      @training_words = UserWord.from_category(@training.user_category)
      expect(@training_words.length).to eq 2

      expect(@training_words).to include(@user_word)
    end
  end
end
