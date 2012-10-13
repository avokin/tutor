module UsersHelper
  def success_count_to_learn(user)
    return 5
  end

  def target_language_select
    options_from_collection_for_select(Language.all, 'id', 'name', current_user.target_language.id)
  end
end
