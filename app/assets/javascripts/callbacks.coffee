# To run all JS init code over an element (e.g. after inserting it using JS), do this:
# new App.Init(element)
$(document).ready ->
  new App.Init @

  $('#images').on('cocoon:after-insert', (e, added_image) ->
    new App.Init added_image
  )
