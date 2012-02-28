###

###

class SuperTest

hintCount = 0

showHint = ->
  expected = $("#expected").get(0)
  len = expected.value.length
  if hintCount == 0
    if len > 3
      len = 3
  else
    skipped = $("#skipped").get(0)
    skipped.value = 1

  hintCount++;

  t = $("#hintContainer").get(0)
  t.innerHTML = expected.value.substring(0, len)

skipTry = ->
  hintCount = 1
  showHint()
  setTimeout('buttonCheck = $("#buttonCheck").get(0); buttonCheck.click();', 2000)

$(
  ->
    $("#hintButton").click(showHint)
    $("#skipButton").click(skipTry)
)