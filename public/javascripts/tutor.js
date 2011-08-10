function documentKeypress(e) {
  if (e.ctrlKey) {
    if (e.keyCode == 9) {
      var wordToSearch = document.getElementById("word_to_search");
      wordToSearch.focus();
    } else if (e.keyCode == 17) {
      if (onCtrlQ != null) {
        onCtrlQ();
      }
    } else if (e.keyCode == 25) {
      if (onCtrlY() != null) {
        onCtrlY();
      }
    } else if (e.keyCode == 2) {
      if (onCtrlB != null) {
        onCtrlB();
      }
    }
  }
}
