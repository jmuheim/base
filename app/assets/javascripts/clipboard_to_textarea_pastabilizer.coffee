# Adds the features of paste.js to all textareas of the given element.
#
# Be sure you have https://github.com/layerssss/paste.js available.
class App.ClipboardToTextareaPastabilizer
  constructor: (el) ->
    $el = $(el)

    @$input            = $el.find('textarea')
    @$previewContainer = $el.find('.thumbnail')
    @$previewImage     = @$previewContainer.find('img')
    @$input.after("<span class='fa fa-image'></span>")

    @removeWhitespace()
    @makePastable()
    @makeResettable()

  # We need to do this because of this problem: https://github.com/nathanvda/cocoon/issues/323
  removeWhitespace: ->
    if @$input.val().trim() == ''
      @$input.val('')

  makeResettable: ->
    @$previewContainer.on 'click', (ev, data) =>
      @setValue('')
      @$input.focus()
      ev.preventDefault()

  makePastable: ->
    @$input.pastableTextarea()
    @$input.on('pasteImage', (ev, data) =>
      @setValue(data.dataURL)
      return
    ).on 'pasteText', (ev, data) ->
      return

  setValue: (dataUrl) ->
    @$input.val(dataUrl)                # Set blog string to textarea
    @$previewImage.attr('src', dataUrl) # Set image preview

    @$previewContainer.toggle() # Show the image preview
    @$previewContainer.focus()  # Focus the image preview
    @$input.toggle()            # Hide the textarea
