class Language < ActiveRecord::Base
  def is_german
    id == 3
  end

  def short_name
    if id == 1
      'ru'
    elsif id == 2
      'en'
    else
      'de'
    end
  end
end
