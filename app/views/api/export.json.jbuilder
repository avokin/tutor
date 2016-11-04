json.languages do
  json.array!(@languages) do |lang|
    json.extract! lang, :id, :name
  end
end

json.words do
  json.array!(@user_words) do |word|
    json.extract! word, :id, :language_id, :text, :comment, :type_id, :custom_int_field1, :custom_string_field1,
        :time_to_check, :success_count
  end
end

json.word_relations do
  json.array!(@word_relations) do |relation|
    json.extract! relation, :id, :source_user_word_id, :related_user_word_id, :relation_type
  end
end

json.categories do
  json.array!(@user_categories) do |category|
    json.extract! category, :id, :name, :is_default, :language_id
  end
end

json.word_categories do
  json.array!(@user_word_categories) do |word_category|
    json.extract! word_category, :user_word_id, :user_category_id
  end
end
