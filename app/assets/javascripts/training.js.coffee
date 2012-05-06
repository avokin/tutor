# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

TRAINING_URL = "/trainings/training_data.json"

ajax_error = (xhr, status, error) ->
  alert(status["responseText"])
  alert("ajax:error" + error)

currentWord = null

show = (data, status, xhr) ->
  currentWord = data
  $("#userWordCell").html("<a href='/user_words/" + currentWord.id+ "'>" + currentWord.word + "</a>")

  answerInput = ""
  i = 0
  while currentWord["answer#{i}"] != undefined
    answerInput += "<tr><td><input id=\"answer#{i}\" class=\"answer#{i}\"/></td></tr>"
    i++
  currentWord.n = i
  $("tbody", "#attemptTable").html(answerInput)

requstUserWord = (id) ->
  if id == null
    request_url = TRAINING_URL
  else
    request_url = TRAINING_URL + "?id=#{id}"
  $.ajax({
      url: request_url
      type: "POST"
      success: show
      error: ajax_error
    })

skip = ->
  requstUserWord(null)

initTraining = (userWordId) ->
  requstUserWord(userWordId)

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
      ok = false
      highlightCorrectAnswer(inputField)
    else
      highlightWrongAnswer(inputField)


`globalInitTraining = initTraining;`

$ ->
  $("#variant_0").select()
  $("#btnSkip").click(skip)
  $("#btnCheck").click(check)
