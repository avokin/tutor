Factory.define :word do |word|
  word.sequence(:text) { |i| "word#{i}" }
  word.sequence(:language_id) { |i| i % 2 + 1 }
end

Factory.define :user_word do |user_word|
  user_word.user { first_user }
  user_word.association :word
end

Factory.define :user_word_for_another_user, :class => :user_word do |user_word|
  user_word.user { second_user }
  user_word.association :word
end

Factory.define :word_relation_translation, :class => :word_relation do |word_relation|
  word_relation.relation_type {1}
  word_relation.association :source_user_word, :factory => :user_word
  word_relation.association :related_user_word, :factory => :user_word
  word_relation.user { first_user }
  word_relation.status_id {1}
  word_relation.success_count {0}
end

Factory.define :word_relation_synonym, :class => :word_relation do |word_relation|
  word_relation.relation_type { 2 }
  word_relation.association :source_user_word, :factory => :user_word
  word_relation.association :related_user_word, :factory => :user_word
  word_relation.user { first_user }
  word_relation.status_id {1}
  word_relation.success_count {0}
end

Factory.define :user do |user|
  user.name                  "Michael Hartl"
  user.sequence(:email) {|i| "test#{i}@gmail.com"}
  user.password              "foobar"
  user.password_confirmation "foobar"
end

Factory.define :user_category do |user_category|
  user_category.user { first_user }
  user_category.sequence(:name) {|i| "category #{i}"}
end

Factory.define :user_word_category do |user_word_category|
  user_word_category.association :user_word
  user_word_category.association :user_category
end

def first_user
  User.first || Factory(:user)
end

def second_user
  while User.all.size < 2
    Factory(:user)
  end
  User.all[1]
end