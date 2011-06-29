Factory.define :word do |factory|
  factory.sequence(:word) { |i| "word#{ i }word" }
end