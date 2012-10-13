module UsersHelper
  def success_count_to_learn(user)
    return 5
  end

  def target_language_select
    result = "<select name='user[target_language_id]'>"
    Language.all.each do |l|
      if l.id != current_user.language.id
        if l.id == current_user.target_language.id
          selected = "selected='selected'"
        else
          selected = ""
        end
        result << "<option #{selected} value='#{l.id}'>#{l.name}</option>"
      end
    end
    result << "</select>"
    result
  end
end
