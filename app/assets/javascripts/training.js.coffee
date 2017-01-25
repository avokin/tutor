TRAINING_URL = "/trainings/training_data.json"

ajax_error = (xhr, status, error) ->
  alert(status["responseText"] + error)

keypress = (event) ->
  if event.which == 13
    btnCheck.click()

`index = 0`

innerSelectTrainingWord = (i) ->
  if i >= words.length
    i = 0

  if i < 0
    i = words.length - 1

  `index = i`
  $("#word_text").prop('href', '/user_words/' + words[index][0]).text(words[index][1])

  $("#word_translations").text('')
  $("#word_prefix").text('')
  $("#word_suffix").text('')


innerShowTrainingWordHint = ->
  $("#word_translations").text(words[index][2])
  $("#word_prefix").text(words[index][3])
  $("#word_suffix").text(words[index][4])

sendTrainingResult = (index, result) ->
  request_url = TRAINING_URL + "?word_id=#{words[index][0]}&result=#{result}"
  $.ajax({
    url: request_url
    type: "POST"
    success: null
    error: ajax_error
  })

innerRemember = (index) ->
  sendTrainingResult(index, true)
  innerSelectTrainingWord(index + 1)

innerForgot = (index) ->
  sendTrainingResult(index, false)
  innerSelectTrainingWord(index + 1)

`selectTrainingWord = innerSelectTrainingWord;`
`showTrainingWordHint = innerShowTrainingWordHint;`
`remember = innerRemember;`
`forgot = innerForgot;`
