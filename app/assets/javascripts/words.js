var translationsCount = 1;
var categoriesCount = 0;
var synonymsCount = 0;

function addInput(parentContainerId, name, autocomplete, value) {
  var parentContainer = document.getElementById(parentContainerId);
  var createdInput = document.createElement("input");
  createdInput.name = name;
  createdInput.id = name;
  if (autocomplete != null) {
    createdInput.setAttribute("data-autocomplete", autocomplete);
  }
  if (value != null) {
      createdInput.value = value;
  }
  parentContainer.appendChild(createdInput);
  createdInput.focus();
}

function addTranslation() {
  translationsCount++;
  addInput("translations", "translation_" + (translationsCount - 1), "/search/autocomplete_user_word_text");
}

function addCategory(name) {
  categoriesCount++;
  addInput("categories", "category_" + (categoriesCount - 1), "/search/autocomplete_user_category_name", name);
}


function addSynonym() {
  categoriesCount++;
  addInput("synonyms", "synonym_" + (synonymsCount - 1), "/search/autocomplete_user_word_text");
}


function onCtrlQ() {
  addTranslation();
}

function onCtrlY() {
  addCategory();
}

function onCtrlB() {
  addSynonym();
}
