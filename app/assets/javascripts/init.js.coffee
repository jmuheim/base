$(document).ready ->
  $('#language_selector').each ->
    new App.LanguageChooser @
