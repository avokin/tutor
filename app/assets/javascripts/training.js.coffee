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
  $("#userWordCell").html("<a href='user_words/" + currentWord.id+ "'>" + currentWord.word + "</a>")

  answerInput = ""
  i = 0
  while currentWord["answer#{i}"] != undefined
    answerInput += "<tr><td><input id=\"answer#{i}\" class=\"answer#{i}\"/></td></tr>"
    i++
  currentWord.n = i - 1
  $("tbody", "#attemptTable").html(answerInput)

requstUserWord = (id) ->
  $.ajax({
      url: id == null ? TRAINING_URL : TRAINING_URL + "?id=#{userWordId}"
      type: "POST"
      success: show
      error: ajax_error
    })

skip = ->
  requstUserWord(null)

initTraining = (userWordId) ->
  requstUserWord(userWordId)

check = ->
  for i in [0...currentWord.n]

  while currentWord["answer#{i}"] != undefined
    $("answer#{i}").value()
    answerInput += "<tr><td><input id=\"answer#{i}\" class=\"answer#{i}\"/></td></tr>"
    i++


`globalInitTraining = initTraining;`

$ ->
  $("#variant_0").select()
  $("#btnSkip").click(skip)
  $("#btnCheck").click(check)
