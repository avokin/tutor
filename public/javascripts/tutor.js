function addTranslation() {
  var translations = document.getElementById("translations");
  var createdInput = document.createElement("input");
  translationsCount++;
  createdInput.name = "translation_" + (translationsCount - 1);
  createdInput.id = createdInput.name;
  createdInput.setAttribute("data-autocomplete", "/search/autocomplete_word_word");
  createdInput.onkeydown = onKeyPressed;
  translations.appendChild(createdInput);
  createdInput.focus();
}

function addCategory() {
  var categories = document.getElementById("categories");
  var createdInput = document.createElement("input");
  categoriesCount++;
  createdInput.name = "category_" + (categoriesCount - 1);
  createdInput.id = createdInput.name;
  createdInput.setAttribute("data-autocomplete", "/search/autocomplete_category_name");
  createdInput.onkeydown = onKeyPressed;
  categories.appendChild(createdInput);
  createdInput.focus();
}

function test11() {
  alert("test")
}

function onKeyPressed() {
  if (!event.ctrlKey) {
    return true;
  }
  if (event.keyCode == 81) {
    if (event.target.id.substring(0, 11) == "translation") {
      addTranslation();
    } else {
      addCategory();
    }

    event.preventDefault();
    return false;
  }
  return true;
}
