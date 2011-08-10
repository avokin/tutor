var translationsCount = 1;
var categoriesCount = 0;

function addInput(parentContainerId, name, autocomplete) {
  var parentContainer = document.getElementById(parentContainerId);
  var createdInput = document.createElement("input");
  createdInput.name = name;
  createdInput.id = name;
  if (autocomplete != null) {
    createdInput.setAttribute("data-autocomplete", autocomplete);
  }
  //createdInput.onkeydown = onKeyPressed;
  parentContainer.appendChild(createdInput);
  createdInput.focus();
}

function addTranslation() {
  translationsCount++;
  addInput("translations", "translation_" + (translationsCount - 1), "/search/autocomplete_word_word");
}

function addCategory() {
  categoriesCount++;
  addInput("categories", "category_" + (categoriesCount - 1), "/search/autocomplete_category_name");
}

function onCtrlQ() {
  addTranslation();
}

function onCtrlY() {
  addCategory();
}

function onKeyPressed() {
  if (!event.ctrlKey) {
    return true;
  }
  if (event.keyCode == 81) {
    if (event.target.id.substring(0, 11) == "translation") {

    } else {

    }

    event.preventDefault();
    return false;
  }
  return true;
}
