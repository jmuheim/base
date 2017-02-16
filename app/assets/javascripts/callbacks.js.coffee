# To run all JS init code over an element (e.g. after inserting it using JS), do this:
# new App.Init(element)
$(document).on 'turbolinks:load', ->
  new App.Init @

$(document).on 'turbolinks:render', (e) ->
  # console.log e.target.title
  $('#headline_title').focus()
  # jQuery.a11yfy.assertiveAnnounce 'hello!'