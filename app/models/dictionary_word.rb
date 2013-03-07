class DictionaryWord < ActiveRecord::Base
  establish_connection :dictionary_database
end
