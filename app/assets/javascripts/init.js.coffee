$(document).ready ->
  # Init your scripts here!
  #
  # Example:
  #
  # $('#some_selector').each ->
  #   new App.ExampleScript @

  # Bootstrap tooltips
  $('[title]').tooltip()

  # Fancybox
  $('a.fancybox').fancybox
    openSpeed: 0
    closeSpeed: 0
    nextSpeed: 0
    prevSpeed: 0
    helpers:
      overlay:
        locked: false
        speedOut: 0
      thumbs:
        width: 100,
        height: 100
