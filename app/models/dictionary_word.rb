class DictionaryWord < ActiveRecord::Base
  if Rails.env == "production"
    dictionary_db = ENV['HEROKU_POSTGRESQL_VIOLET_URL']
  else
    dictionary_db = :dictionary_database
  end

  establish_connection dictionary_db
end
