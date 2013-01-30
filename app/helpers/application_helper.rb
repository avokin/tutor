module ApplicationHelper
  ANOTHER_USER_ERROR_MESSAGE = "You are trying to access to object that created by another user"
  NOT_SIGNED_IN_USER_ERROR_MESSAGE = "You must sign in!"
  def logo
    image_tag('logo.png', :alt => 'Tutor', :class => "logo")
  end

  # put this in the body after a form to set the input focus to a specific control id
  # at end of rhtml file: <%= set_focus_to_id 'form_field_label' %>
  def set_focus_to_id(id)
    javascript_tag("$('##{id}').focus()");
  end

  def target_language
    current_user.target_language.name
  end

  def not_target_language
    target_lang = current_user.target_language
    native_lang = current_user.language
    other_languages = Language.all.find_all{|language| language.id != target_lang.id && language.id != native_lang.id};
    content_tag :ul, :class => "dropdown-menu" do
      other_languages.collect do |language|
        concat(content_tag(:li, link_to(language.name, "/users/set_target_language?id=#{language.id}")))
      end
    end
  end

  private

  def authenticate_user
    deny_access if current_user.nil?
  end

  def deny_access
    redirect_to signin_path, :flash => {:error => NOT_SIGNED_IN_USER_ERROR_MESSAGE}
  end
end
