var hintCount = 0;

function showHint() {
  var expected = $("#expected").get(0);
  var len = expected.value.length;
  if (hintCount == 0) {
    if (len > 3) {
      len = 3;
    }
  } else {
    var skipped = $("#skipped").get(0);
    skipped.value = 1;
  }
  hintCount++;

  var t = $("#hintContainer").get(0);
  t.innerHTML = expected.value.substring(0, len)
}

function submitSkip() {
  var buttonCheck = $("#buttonCheck").get(0);
  buttonCheck.click();
}

function skipTry() {
  hintCount = 1;
  showHint();
  setTimeout('submitSkip()', 2000)
}