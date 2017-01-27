class KeyboardProcessor
  onLeftPressed: -> false
  onRightPressed: -> false
  onFPressed: -> false
  onSpacePressed: -> false
  onJPressed: -> false

document.keyboardProcessor = new KeyboardProcessor()

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
    #else if e.keyCode == 2
    #ctrl + B
  else if e.keyCode == 115 || e.keyCode == 83
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

