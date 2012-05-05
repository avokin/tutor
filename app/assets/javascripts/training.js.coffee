# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

displayTraining = (data, status, xhr) ->
  $("#userWordCell").html("<a href='user_words/" + data.id+ "'>" + data.word + "</a>")

  answerInput = ""
  i = 0
  while data["answer#{i}"] != undefined
    answerInput += "<tr><td><input id=\"answer#{i}\" class=\"answer#{i}\"/></td></tr>"
    i++
  $("tbody", "#attemptTable").html(answerInput)

skip = ->
  $.ajax({
    url: "/trainings/training_data.json"
    type: "POST"
    success: displayTraining
    error: ajax_error
  })

ajax_error = (xhr, status, error) ->
  alert(status["responseText"])
  alert("ajax:error" + error)

initTraining = (userWordId) ->
  $.ajax({
    url: "/trainings/training_data.json?id=#{userWordId}"
    type: "POST"
    success: displayTraining
    error: ajax_error
  })

`globalInitTraining = initTraining;`

$ ->
  $("#variant_0").select()
  $("#btnSkip").click(skip)
