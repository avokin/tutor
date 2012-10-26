def first_language
  while Language.all.size < 3
    FactoryGirl.create(:language)
  end
  Language.first
end

def first_user
  User.first || FactoryGirl.create(:user)
end

def second_user
  while User.all.size < 2
    FactoryGirl.create(:user)
  end
  User.all[1]
end

FactoryGirl.define do
  factory :word do |word|
    word.sequence(:text) { |i| "word#{i}" }
    word.sequence(:language_id) { |i| i % 2 + 1 }
  end

  factory :english_word, :class => :word do |word|
    word.sequence(:text) { |i| "english#{i}" }
    word.language_id { 2 }
  end

  factory :russian_word, :class => :word do |word|
    word.sequence(:text) { |i| "russian#{i}" }
    word.language_id { 1 }
  end

  factory :german_word, :class => :word do |word|
    word.sequence(:text) { |i| "german#{i}" }
    word.language_id { 3 }
  end

  factory :user_word do |user_word|
    user_word.user { first_user }
    user_word.time_to_check { DateTime.new(2001, 2, 3, 4, 5, 6) }
    user_word.association :word
  end

  factory :english_user_word, :class => :user_word do |user_word|
    user_word.user { first_user }
    user_word.time_to_check { DateTime.new(2001, 2, 3, 4, 5, 6) }
    user_word.association :word, :factory => :english_word
  end

  factory :russian_user_word, :class => :user_word do |user_word|
    user_word.user { first_user }
    user_word.time_to_check { DateTime.new(2001, 2, 3, 4, 5, 6) }
    user_word.association :word, :factory => :russian_word
  end

  factory :german_user_word, :class => :user_word do |user_word|
    user_word.user { first_user }
    user_word.time_to_check { DateTime.new(2001, 2, 3, 4, 5, 6) }
    user_word.association :word, :factory => :german_word
  end

  factory :user_word_for_another_user, :class => :user_word do |user_word|
    user_word.user { second_user }
    user_word.association :word
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
    user.name "UserName UserSurname"
    user.sequence(:email) { |i| "test#{i}@gmail.com" }
    user.password "password"
    user.password_confirmation "password"
    user.success_count 5
    user.language { first_language }
  end

  factory :language do |language|
    language.sequence(:name) { |i| case i % 3
                                     when 1
                                       "English"
                                     when 2
                                       "Russian"
                                     when 0
                                       "Deutsch"
      end
    }
  end

  factory :user_category do |user_category|
    user_category.user { first_user }
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
end