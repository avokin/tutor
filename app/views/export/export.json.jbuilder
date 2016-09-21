json.array!(@languages) do |lang|
  json.extract! lang, :id, :name
end

json.array!(@user_words) do |word|
  json.extract! word, :id, :language_id, :text, :comment, :type_id, :custom_int_field1, :custom_string_field1
end

# json.array!(@word_relations) do |relation|
#   json.extract! relation, :id, :source_user_word_id, :related_user_word_id, :relation_type
# end

json.array!(@user_categories) do |category|
  json.extract! category, :id, :name, :is_default, :language_id
end

# json.array!(@user_word_categories) do |word_category|
#   json.extract! word_category, :user_word_id, :user_category_id
# end
