# Adds the features of paste.js to all textareas of the given element.
#
# Be sure you have https://github.com/layerssss/paste.js available.
class App.ClipboardToNestedResourcePastabilizer
  class ImagePaster
    constructor: ($input, pastedData) ->
      @$input     = $input
      @pastedData = pastedData

      # Add another nested fields element
      @$allNestedFields = $('#images')
      @$allNestedFields.find('a.add_fields').click()

      # The last nested fields element is the new one
      @$newNestedFields = @$allNestedFields.find('.nested-fields:last')

      @identifier_field = @$newNestedFields.find(':input[id$="_identifier"]')
      @file_field       = @$newNestedFields.find(':input[id$="_file"]')
      @previewContainer = @$newNestedFields.find('.thumbnail')
      @previewImage     = @previewContainer.find('img')

      @alternative_text = @examineAlternativeText()
      @identifier       = @examineIdentifier()

    examineAlternativeText: ->
      prompt(@$input.data('pastable-image-alt-prompt'))

    examineIdentifier: ->
      identifier = prompt(@$input.data('pastable-image-identifier-prompt'), @slugify(@alternative_text))

      if identifier == ''
        @identifier_field.attr('id').match(/_(\d+)_identifier$/)[1]
      else
        identifier

    run: ->
      return if @alternative_text == null || @identifier == null # Cancel!

      @file_field.val(@pastedData.dataURL)                             # Set blob string to textarea
      @previewImage.attr('src', URL.createObjectURL(@pastedData.blob)) # Set image preview
      @previewContainer.toggle()                                # Show the image preview
      @file_field.toggle()                                      # Hide the textarea
      @identifier_field.val(@identifier)

      @insertImageStringIntoTextarea(@alternative_text, @identifier)

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

  # class CodePaster
  #   constructor: ($elements) ->
  #     @$elements = $elements
  #
  #     @identifier_field  = @$elements.find(':input[id$="_identifier"]')
  #     @title_field       = @$elements.find(':input[id$="_title"]')
  #     @description_field = @$elements.find(':input[id$="_description"]')
  #     @html_field        = @$elements.find(':input[id$="_html"]')
  #     @css_field         = @$elements.find(':input[id$="_css"]')
  #     @js_field          = @$elements.find(':input[id$="_js"]')
  #
  #   getTemporaryIdentifierId: ->
  #     @identifier_field.attr('id').match(/_(\d+)_identifier$/)[1]

  constructor: (el) ->
    @$input = $(el)
    @$input.after("<span class='fa fa-image'></span>")

    # TODO: Do something that can be tested using Capybara to make sure that at least the initialisation of stuff works!
    @$input.pastableTextarea()

    @$input.on('pasteImage', (ev, pastedData) =>
      imagePaster = new ImagePaster(@$input, pastedData)
      imagePaster.run()
    ).on 'pasteText', (ev, pastedData) ->
