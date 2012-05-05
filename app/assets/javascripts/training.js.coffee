# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $("#variant_0").select()
  $("#btnCheck").click()

displayTraining = (data, status, xhr) ->
  $("#userWordCell").html("<a href='user_words/" + userWordId+ "'>" + data.word + "</a>")

  answerInput = ""
  i = 0
  while data["answer#{i}"] != undefined
    answerInput += "<tr><td><input id=\"answer#{i}\" class=\"answer#{i}\"/></td></tr>"
    i++
  $("tbody", "#attemptTable").html(answerInput)

ajax_error = (xhr, status, error) ->
  alert(status["responseText"])
  alert("ajax:error" + error)

userWordId = -1

initTraining = (uwId) ->
  userWordId = uwId
  $.ajax({
    url: "/trainings/#{userWordId}/training_data.json"
    type: "POST"
    success: displayTraining
    error: ajax_error
  })

`globalInitTraining = initTraining;`
