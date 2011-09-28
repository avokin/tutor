Factory.define :word do |word|
  word.sequence(:text) { |i| "word#{i}" }
  word.sequence(:language_id) { |i| i % 2 + 1 }
end

Factory.define :user_word do |user_word|
  user_word.association :user
  user_word.association :word
end

Factory.define :word_relation do |word_relation|
  word_relation.sequence(:relation_type) { 1 }
  word_relation.sequence(:source_user_word_id) { |i| i}
  word_relation.sequence(:related_user_word_id) { |i| i + 1}
  word_relation.association :user
end

Factory.define :user do |user|
  user.name                  "Michael Hartl"
  user.sequence(:email) {|i| "test#{i}@gmail.com"}
  user.password              "foobar"
  user.password_confirmation "foobar"
end