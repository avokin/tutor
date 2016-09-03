json.array!(@user_words) do |word|
  json.extract! word, :id, :language_id, :text, :comment, :type_id, :custom_int_field1, :custom_string_field1
end
