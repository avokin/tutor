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

  def init_languages
    if Language.all.count == 0
      english = Language.new :name => "English"
      english.save!
      russian = Language.new :name => "Russian"
      russian.save!
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
