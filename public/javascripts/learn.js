function showHint() {
    len = expected.value.length;
    if (len > 3) {
        len = 3;
    }
    answer.value = expected.value.substring(0, len)
}

function submitSkip() {
    buttonCheck.click();
}

function skipTry() {
    answer.value = expected.value;
    skipped.value = 1;
    setTimeout('submitSkip()', 2000)
}