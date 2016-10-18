require 'spec_helper'

describe UserCategory do
  before(:each) do
    init_db
  end

  describe 'find by user and name' do
    before(:each) do
      @category = FactoryGirl.create(:user_category)
      FactoryGirl.create(:user_category)
    end

    it 'should find category for the first user' do
      expect(UserCategory.find_by_user_and_name(first_user, @category.name)).to eq @category
    end

    it "shouldn't find category by the wrong name" do
      expect(UserCategory.find_by_user_and_name(first_user, 'wrong category name')).to be_nil
    end

    it "shouldn't find category of the another language" do
      user = first_user
      user.target_language = german_language
      user.save!
      expect(UserCategory.find_by_user_and_name(first_user, @category.name)).to be_nil
    end

    it "shouldn't find category for another user" do
      expect(UserCategory.find_by_user_and_name(second_user, @category.name)).to be_nil
    end
  end

  describe 'delete category' do
    before(:each) do
      @user_word_category = FactoryGirl.create(:user_word_category)
      @user_category = @user_word_category.user_category

      @training = FactoryGirl.create(:training, :user_category => @user_category)
    end

    it 'should delete relation to user words' do
      @user_category.destroy
      expect(UserWordCategory.find_by_id(@user_word_category.id)).to be_nil
    end

    it 'should delete relation to user words' do
      @user_category.destroy
      expect(Training.find_by_id(@training.id)).to be_nil
    end
  end

  describe 'merge' do
    describe 'authorized access' do
      before(:each) do
        @merging_categories = Array.new
        @merging_categories << FactoryGirl.create(:user_word_category).user_category.id
        @merging_categories << FactoryGirl.create(:user_word_category).user_category.id
        @merging_categories << FactoryGirl.create(:user_word_category).user_category.id

        @word_count = @merging_categories.length
      end

      it 'should delete merging categories' do
        first = @merging_categories[0]
        expect(UserCategory.merge(first_user, @merging_categories)).to be true

        @merging_categories.each do |merging_category_id|
          expect(UserCategory.exists?(merging_category_id)).to eq (first == merging_category_id)
        end
      end

      it 'should move all words from merging categoreis to the main one' do
        expect(UserCategory.merge(first_user, @merging_categories)).to be true

        main_category = UserCategory.find(@merging_categories[0])
        expect(main_category.user_words.length).to eq @word_count
      end

      it 'should skip categories from another languages' do
        last = FactoryGirl.create(:user_category, :language => german_language)
        word = FactoryGirl.create(:german_user_word)
        FactoryGirl.create(:user_word_category, :user_word => word, :user_category => last)
        @merging_categories << last.id

        expect(UserCategory.merge(first_user, @merging_categories)).to eq false

        @merging_categories.each do |merging_category_id|
          expect(UserCategory.exists?(merging_category_id)).to eq true
        end

        expect(last.user_words.length).to eq 1
      end
    end

    describe 'unauthorized access' do
      before(:each) do
        @merging_categories = Array.new
        @merging_categories << FactoryGirl.create(:user_category, :user => second_user).id
        @merging_categories << FactoryGirl.create(:user_word_category).user_category.id
        @merging_categories << FactoryGirl.create(:user_word_category).user_category.id

        @word_count = @merging_categories.length
      end

      it 'should return false in cause of categories of another user' do
        expect(UserCategory.merge(first_user, @merging_categories)).to be false
      end

      it 'should return false in cause of categories of another user' do
        expect(UserCategory.merge(second_user, @merging_categories)).to be false
      end

      it 'should not merge categories' do
        @merging_categories.each do |merging_category_id|
          expect(UserCategory.exists?(merging_category_id)).to be true
          expect(UserCategory.find(merging_category_id).user_words.length).to eq (merging_category_id == @merging_categories[0] ? 0 : 1)
        end
      end
    end
  end

  describe 'find_by_is_default' do
    before :each do
      @default_category = FactoryGirl.create(:user_category, :is_default => true)
      FactoryGirl.create(:user_category)
      FactoryGirl.create(:user_category, :is_default => true, :language => german_language)
    end

    it 'should find only default category of current language' do
      categories = UserCategory.find_all_by_is_default first_user
      expect(categories.length).to eq 1
      expect(categories[0].id).to eq @default_category.id
    end
  end

  describe 'all_with_info' do
    before do
      @category = FactoryGirl.create(:user_word_category).user_category
      FactoryGirl.create(:user_word_category, user_category: @category)

      UserWord.first.time_to_check = DateTime.now
      last = UserWord.last
      last.time_to_check = DateTime.now + 1.day
      last.save!
    end

    it 'should have two words and one of them ready' do
      categories = UserCategory.all_with_info(@category.user)

      expect(categories.length).to eq(1)
      category = categories.first

      expect(category.words_count).to eq(2)
      expect(category.ready_words_count).to eq(1)
    end

  end
end
