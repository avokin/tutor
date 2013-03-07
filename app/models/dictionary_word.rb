class DictionaryWord < ActiveRecord::Base
  establish_connection ENV['HEROKU_POSTGRESQL_VIOLET_URL']
end
