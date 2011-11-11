documentKeypress = (e) ->
  if e.ctrlKey
    # i
    if e.keyCode == 9
      wordToSearch = document.getElementById("search_word");
      wordToSearch.focus()
    else if e.keyCode == 17
      if (onCtrlQ != null)
        onCtrlQ()
    else if e.keyCode == 25
      if onCtrlY() != null
        onCtrlY()
    else if e.keyCode == 2
      if onCtrlB != null
        onCtrlB()

    # s or S
  else if e.keyCode == 115 || e.keyCode == 83
    if e.srcElement.type isnt "text"
      wordToSearch = $("#search_word").get(0)
      wordToSearch.focus()
      false

$(
  ->
    $(document).ready(->
      $("a#shortkeys").fancybox()
      document.onkeypress = documentKeypress
    )
)