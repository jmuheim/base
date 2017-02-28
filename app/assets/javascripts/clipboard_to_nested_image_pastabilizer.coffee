# Adds the features of paste.js to all textareas of the given element.
#
# Be sure you have https://github.com/layerssss/paste.js available.
class App.ClipboardToNestedImagePastabilizer
  class ImageFields
    constructor: ($images) ->
      @$images = $images

      @file_field       = @$images.find(':input[id$="_file"]')
      @identifier_field = @$images.find(':input[id$="_identifier"]')
      @previewContainer = @$images.find('.thumbnail')
      @previewImage     = @previewContainer.find('img')

    getTemporaryIdentifierId: ->
      @file_field.attr('id').match(/_(\d+)_file$/)[1]

  constructor: (el) ->
    @$input = $(el)
    @$input.after("<span class='fa fa-image'></span>")

    @$images           = $('#images')
    @$add_image_link   = @$images.find('a.add_fields')
    @alt_prompt        = @$input.data('pastable-image-alt-prompt')
    @identifier_prompt = @$input.data('pastable-image-identifier-prompt')

    @makePastable() # TODO: Do something that can be tested using Capybara to make sure that at least the initialisation of stuff works!

  makePastable: ->
    @$input.pastableTextarea()

    @$input.on('pasteImage', (ev, data) =>
      alternative_text = prompt(@alt_prompt) # Get alternative text from user
      return if alternative_text == null     # Cancel?

      identifier = prompt(@identifier_prompt, @slugify(alternative_text)) # Get identifier from user (propose slugified alternative text)
      return if identifier == null                                        # Cancel?

      @$add_image_link.click() # Add another file input field
      imageFields = new ImageFields(@$images.find('.nested-fields:last'))

      temporary_identifier_id = imageFields.getTemporaryIdentifierId()
      identifier = temporary_identifier_id if identifier == ''

      imageFields.file_field.val(data.dataURL)                             # Set blob string to textarea
      imageFields.previewImage.attr('src', URL.createObjectURL(data.blob)) # Set image preview
      imageFields.previewContainer.toggle()                                # Show the image preview
      imageFields.file_field.toggle()                                      # Hide the textarea
      imageFields.identifier_field.val(identifier)

      @insertImageStringIntoTextarea(alternative_text, identifier)
      return
    ).on 'pasteText', (ev, data) ->
      return

  insertImageStringIntoTextarea: (alternative_text, identifier) ->
    caret_position = @$input.caret()

    value_before = @$input.val().substring(0, caret_position)
    value_after  = @$input.val().substring(caret_position)
    image_string = "![#{alternative_text}](@image-#{identifier})"

    @$input.val(value_before + image_string + value_after)
    @$input.caret(caret_position + image_string.length)

  # https://gist.github.com/mathewbyrne/1280286
  slugify: (text) ->
    text.toString().toLowerCase().replace(/\s+/g, '-').replace(/[^\w\-]+/g, '').replace(/\-\-+/g, '-').replace(/^-+/, '').replace /-+$/, ''