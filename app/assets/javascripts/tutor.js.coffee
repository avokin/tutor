class KeyboardProcessor
  onLeftPressed: -> true
  onRightPressed: -> true
  onFPressed: -> true
  onSpacePressed: -> true
  onJPressed: -> true

document.keyboardProcessor = new KeyboardProcessor()

inputKeypress = (e) ->
  if e.ctrlKey
    console.log(e.keyCode)
    if e.keyCode == 9 || e.keyCode == 83
      # s
      wordToSearch = document.getElementById("search_text");
      wordToSearch.focus()
    else if e.keyCode == 84
      # t
      translation_0 = document.getElementById("translation_0");
      translation_0.focus()
    else if e.keyCode == 82
      # r
      synonym_0 = document.getElementById("synonym_0");
      synonym_0.focus()
    else if e.keyCode == 65
      # a
      comment = document.getElementById("user_word_comment");
      comment.focus()
    else if e.keyCode == 67
      # c
      category = document.getElementById("category_0");
      category.focus()

documentKeypress = (e) ->
  inputKeypress(e)
  if e.keyCode == 115 || e.keyCode == 83
    # s or S
    if e.srcElement.type isnt "text" and e.srcElement.type isnt 'textarea'
      wordToSearch = $("#search_text").get(0)
      wordToSearch.focus()
      false
  else if e.keyCode == 37
    document.keyboardProcessor.onLeftPressed()
  else if e.keyCode == 39
    document.keyboardProcessor.onRightPressed()
  else if e.keyCode == 70
    document.keyboardProcessor.onFPressed()
  else if e.keyCode == 32
    document.keyboardProcessor.onSpacePressed()
  else if e.keyCode == 74
    document.keyboardProcessor.onJPressed()
$ ->
  $(document).ready ->
    document.onkeydown = documentKeypress

  $('input:text').keydown(inputKeypress)

  wordToSearch = $("#search_text").focus()
