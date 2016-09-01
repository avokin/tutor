json.array!(@user_words) do |word|
  json.extract! word, :id, :text
end
