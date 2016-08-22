$ ->
  $("#user_word_type_id").change ->
    new_type = $("#user_word_type_id").val()
    href = window.location.href
    if ///type_id=[0-9]///.test(href)
      new_path = href.replace(///type_id=[0-9]///, "type_id=" + new_type)
    else
      if href.includes('?')
        separator = '&'
      else
        separator = '?'
      new_path = href + separator + "type_id=" + new_type
    window.location = new_path