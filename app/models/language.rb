class Language < ActiveRecord::Base
  def is_german
    id == 3
  end
end
