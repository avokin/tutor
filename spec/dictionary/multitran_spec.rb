require 'nokogiri'
require 'spec_helper'

describe 'Multitran' do
  before(:each) do
    init_db
  end

  describe 'translation' do
    before(:each) do
      @parser = GermanMultitranParser.new
      @user_word = FactoryGirl.create(:german_user_word)
    end

    it 'should parse german article' do
      doc = Nokogiri::HTML(IO.read('lib/translation/german_hund.html', encoding: 'windows-1251'))
      @parser.parse(doc, @user_word)
      expect(@user_word.direct_translations.length).to eq(3)

      @user_word.direct_translations.each do |translation|
        expect(%w(бестия зараза сука)).to include(translation.related_user_word.text)
      end

      expect(@user_word.type_id).to eq(2)
      expect(@user_word.custom_int_field1).to eq(2)
      expect(@user_word.custom_string_field1).to eq('-e')
    end
  end
end