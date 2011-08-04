function addTranslation() {
  var translations = document.getElementById("translations");
  var createdInput = document.createElement("input");
  translationsCount++;
  createdInput.name = "translation_" + (translationsCount - 1);
  createdInput.onkeypress = onKeyPressed;
  translations.appendChild(createdInput);
  createdInput.focus();
}

function addCategory() {
  var translations = document.getElementById("category");
  var createdInput = document.createElement("input");
  categoriesCount++;
  createdInput.name = "category_" + (categoriesCount - 1);
  createdInput.onkeypress = onKeyPressed;
  createdInput.setAttribute("data-autocomplete", "/search/autocomplete_category_name");
  categories.appendChild(createdInput);
  createdInput.focus();
}

function onKeyPressed() {
  if (event.keyCode != null) {
    if (event.keyCode == 9) {
      if (event.target.id.substring(0, 11) == "translation") {
        addTranslation();
      } else {
        addCategory();
      }

      event.preventDefault();
      return false;
    }
  }
  return true;
}
