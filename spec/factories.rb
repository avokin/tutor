Factory.define :word do |word|
  word.sequence(:word) { |i| "word#{i}" }
  word.sequence(:language_id) { |i| i % 2 + 1 }
end

Factory.define :word_relation do |word_relation|
  word_relation.sequence(:relation_type) { |i| 1 }
  word_relation.sequence(:source_word_id) { |i| i}
  word_relation.sequence(:related_word_id) { |i| i + 1}
end
