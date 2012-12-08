documentKeypress = (e) ->
  if e.ctrlKey
    # i
    if e.keyCode == 9
      wordToSearch = document.getElementById("search_text");
      wordToSearch.focus()
    else if e.keyCode == 17
      translation_0 = document.getElementById("translation_0");
      translation_0.focus()
    else if e.keyCode == 25
      synonym_0 = document.getElementById("synonym_0");
      synonym_0.focus()
    else if e.keyCode == 2
      #ctrl + B
  else if e.keyCode == 115 || e.keyCode == 83
    # s or S
    if e.srcElement.type isnt "text"
      wordToSearch = $("#search_text").get(0)
      wordToSearch.focus()
      false

$(
  ->
    $(document).ready(->
      $("a#shortkeys").fancybox()
      document.onkeypress = documentKeypress
    )
)