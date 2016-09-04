json.array!(@categories) do |category|
  json.extract! category, :id, :name, :is_default
end
