# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

TRAINING_URL = "/trainings/training_data.json"
HINT_STATUS_NO_HINT = 0
HINT_STATUS_HINT = 1

ajax_error = (xhr, status, error) ->
  alert(status["responseText"])
  alert("ajax:error" + error)

keypress = (event) ->
  if event.which == 13
    btnCheck.click()

currentWord = null
hintStatus = HINT_STATUS_NO_HINT

show = (data, status, xhr) ->
  if data.status == "finished"
    $("#trainingContent").html("There are no ready words in the current training. <br/> Have a rest or choose another training.");
    return
  hintStatus = HINT_STATUS_NO_HINT

  currentWord = data
  $("#userWordCell").html("<a href='/user_words/" + currentWord.id + "'>" + currentWord.word + "</a>")

  hintBlockContent = "<ul>"
  answerInput = ""
  i = 0
  while currentWord["answer#{i}"] != undefined
    answerInput += "<tr><td><input id=\"answer#{i}\" class=\"variant\"/></td><td class=\"answer#{i}\"></td></tr>"
    hintBlockContent += "<li>#{currentWord["answer#{i}"]}</li>"
    i++
  hintBlockContent += "</ul>"
  $("#hintBlock").html(hintBlockContent)

  currentWord.n = i
  $("tbody", "#attemptTable").html(answerInput)
  $(".variant").keypress(keypress)
  $("input#answer0").select()

requstUserWord = (id, result) ->
  onSuccess = show
  if id == null
    if result != null
      if !result
        onSuccess = null
      request_url = TRAINING_URL + "?previous_id=#{currentWord.id}&result=#{result}"
    else
      request_url = TRAINING_URL
  else
    request_url = TRAINING_URL + "?id=#{id}"
  $.ajax({
      url: request_url
      type: "POST"
      success: onSuccess
      error: ajax_error
    })

skip = ->
  requstUserWord(null, null)

showAnswers = (firstLetter) ->
  for i in [0...currentWord.n]
    s = currentWord["answer#{i}"]
    if firstLetter
      s = s.charAt(0)
    $(".answer#{i}").html(s)

hint = ->
  if hintStatus == HINT_STATUS_NO_HINT
    sendTrainingResult(false)
    hintStatus = HINT_STATUS_HINT
    showAnswers(true)
  else
    showAnswers(false)
  $("input#answer0").select()


initTraining = (userWordId) ->
  requstUserWord(userWordId, null)

sendTrainingResult = (result) ->
  requstUserWord(null, result)

isCorrectVariant = (variant) ->
  for i in [0...currentWord.n]
    if currentWord["answer#{i}"] == variant
      return true
  false

highlightInputField = (field, className) ->
  parent = field.parent()
  parent.attr("class", className)

highlightWrongAnswer = (field) ->
  highlightInputField(field, "control-group error")

highlightCorrectAnswer = (field) ->
  highlightInputField(field, "control-group success")

check = ->
  ok = true
  for i in [0...currentWord.n]
    inputField = $("#answer#{i}")
    variant = inputField.val()
    if isCorrectVariant(variant)
      highlightCorrectAnswer(inputField)
    else
      ok = false
      highlightWrongAnswer(inputField)
  if ok
    sendTrainingResult(ok)
  else
    sendTrainingResult(ok)


`globalInitTraining = initTraining;`

$ ->
  $("#btnSkip").click(skip)
  $("#btnCheck").click(check)
  $("#btnHint").click(hint)
  $('#hint').turn(
    display: 'double',
    acceleration: true,
    gradients: !$.isTouch,
    duration: 1000,
    elevation:50,
    when: {turned: (e, page) ->}
  )

  $(window).bind('keydown', (e) ->
      if (e.keyCode==37)
        $('#hint').turn('previous');
      else if (e.keyCode==39)
        $('#hint').turn('next');

  )
