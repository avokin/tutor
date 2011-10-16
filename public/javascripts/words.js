var translationsCount = 1;
var categoriesCount = 0;
var synonymsCount = 0;

function addInput(parentContainerId, name, autocomplete) {
  var parentContainer = document.getElementById(parentContainerId);
  var createdInput = document.createElement("input");
  createdInput.name = name;
  createdInput.id = name;
  if (autocomplete != null) {
    createdInput.setAttribute("data-autocomplete", autocomplete);
  }
  parentContainer.appendChild(createdInput);
  createdInput.focus();
}

function addTranslation() {
  translationsCount++;
  addInput("translations", "translation_" + (translationsCount - 1), "/search/autocomplete_word_word");
}

function addCategory() {
  categoriesCount++;
  addInput("user_categories", "category_" + (categoriesCount - 1), "/search/autocomplete_category_name");
}

function addSynonym() {
  categoriesCount++;
  addInput("synonyms", "synonym_" + (synonymsCount - 1), "/search/autocomplete_word_word");
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
