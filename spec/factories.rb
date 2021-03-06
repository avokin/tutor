def init_db
  while Language.all.size < 3
    FactoryBot.create(:language)
  end
end

def russian_language
  Language.find_by_name('Russian')
end

def german_language
  Language.find_by_name('Deutsch')
end

def english_language
  Language.find_by_name('English')
end

def second_language
  while Language.all.size < 3
    FactoryBot.create(:language)
  end
  Language.all[1]
end

def first_user(target_language = english_language)
  User.first || FactoryBot.create(:user, target_language: target_language)
end

def second_user
  while User.all.size < 2
    FactoryBot.create(:user)
  end
  User.all[1]
end

FactoryBot.define do
  factory :language do |language|
    language.sequence(:name) do |i| case i % 3
                                     when 1
                                       'English'
                                     when 2
                                       'Russian'
                                     when 0
                                       'Deutsch'
      end
    end
  end

  factory :english_user_word, :class => :user_word do |user_word|
    user_word.user { first_user }
    user_word.time_to_check { DateTime.new(2001, 2, 3, 4, 5, 6) }
    user_word.sequence(:text) { |i| "english#{i}" }
    user_word.language { english_language }
    user_word.comment { '' }
  end

  factory :russian_user_word, :class => :user_word do |user_word|
    user_word.user { first_user }
    user_word.time_to_check { DateTime.new(2001, 2, 3, 4, 5, 6) }
    user_word.sequence(:text) { |i| "russian#{i}" }
    user_word.language { russian_language }
  end

  factory :german_user_word, :class => :user_word do |user_word|
    user_word.user { first_user }
    user_word.time_to_check { DateTime.new(2001, 2, 3, 4, 5, 6) }
    user_word.sequence(:text) { |i| "german#{i}" }
    user_word.language { german_language }
  end

  factory :user_word_for_another_user, :class => :user_word do |user_word|
    user_word.user { second_user }
    user_word.sequence(:text) { |i| "german#{i}" }
    user_word.language_id { 3 }
  end

  factory :word_relation_translation, :class => :word_relation do |word_relation|
    word_relation.relation_type { 1 }
    word_relation.association :source_user_word, :factory => :english_user_word
    word_relation.association :related_user_word, :factory => :russian_user_word
    word_relation.user { first_user }
    word_relation.status_id { 1 }
  end

  factory :word_relation_synonym, :class => :word_relation do |word_relation|
    word_relation.relation_type { 2 }
    word_relation.association :source_user_word, :factory => :english_user_word
    word_relation.association :related_user_word, :factory => :english_user_word
    word_relation.user { first_user }
    word_relation.status_id { 1 }
  end

  factory :user do |user|
    user.name 'UserName UserSurname'
    user.sequence(:email) { |i| "test#{i}@gmail.com" }
    user.password 'password'
    user.password_confirmation 'password'
    user.success_count 5
    user.language do
      Language.find_by_name('Russian')
    end
    user.target_language { Language.find_by_name('English') }
  end

  factory :user_category do |user_category|
    user_category.user { first_user }
    user_category.language {first_user.target_language}
    user_category.sequence(:name) { |i| "category #{i}" }
    user_category.is_default false
  end

  factory :user_word_category do |user_word_category|
    user_word_category.association :user_word, :factory => :english_user_word
    user_word_category.association :user_category
  end

  factory :training do |training|
    training.association :user_category
    training.direction { :direct }
    training.user { first_user }
  end

  factory :german_noun, :class => :user_word do |german_noun|
    german_noun.user { first_user }
    german_noun.time_to_check { DateTime.new(2001, 2, 3, 4, 5, 6) }
    german_noun.sequence(:text) { |i| "Oma#{i}" }
    german_noun.language_id { 3 }

    german_noun.type_id { 1 }
    german_noun.custom_string_field1 { 'die' }
    german_noun.custom_string_field2 { 'Omas' }
  end
end