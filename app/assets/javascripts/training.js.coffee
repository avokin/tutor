# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

TRAINING_URL = "/trainings/training_data.json"

ajax_error = (xhr, status, error) ->
  alert(status["responseText"])
  alert("ajax:error" + error)

keypress = (event) ->
  if event.which == 13
    btnCheck.click()

currentWord = null

show = (data, status, xhr) ->
  currentWord = data
  $("#userWordCell").html("<a href='/user_words/" + currentWord.id+ "'>" + currentWord.word + "</a>")

  answerInput = ""
  i = 0
  while currentWord["answer#{i}"] != undefined
    answerInput += "<tr><td><input id=\"answer#{i}\" class=\"variant\"/></td></tr>"
    i++
  currentWord.n = i
  $("tbody", "#attemptTable").html(answerInput)
  $(".variant").keypress(keypress)

requstUserWord = (id, result) ->
  onSuccess = show
  if id == null
    if result != undefined
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
  $("#variant_0").select()
  $("#btnSkip").click(skip)
  $("#btnCheck").click(check)
