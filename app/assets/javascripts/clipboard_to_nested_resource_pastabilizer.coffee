# Adds the features of paste.js to all textareas of the given element.
#
# Be sure you have https://github.com/layerssss/paste.js available.
class App.ClipboardToNestedResourcePastabilizer
  class AbstractPaster
    constructor: ($input, pastedData) ->
      @$input     = $input
      @pastedData = pastedData

      @prepareNestedFields()
      @prepareIdentifierField()

      stringForInput = @stringForInput()
      @insertStringIntoInput(stringForInput) unless stringForInput == null

    prepareNestedFields: ->
      # Add another nested fields element
      @$allNestedFields = $(@nestedFieldsIdentifier())
      @$allNestedFields.find('a.add_fields').click()

      # The last nested fields element is the new one
      @$newNestedFields = @$allNestedFields.find('.nested-fields:last')

    prepareIdentifierField: ->
      @identifier_field = @$newNestedFields.find(':input[id$="_identifier"]')

    insertStringIntoInput: (string) ->
      caret_position = @$input.caret()

      value_before = @$input.val().substring(0, caret_position)
      value_after  = @$input.val().substring(caret_position)

      @$input.val(value_before + string + value_after)
      @$input.caret(caret_position + string.length)

    nestedFieldsIdentifier: ->
      throw ("Implement in sub class!")
      # In sub class, return ID of nested fields container, e.g. '#images'!

    stringForInput: ->
      throw ("Implement in sub class!")
      # In sub class, return string for inserting into input! In addition, you can do other stuff, e.g. displaying a pasted image.

  class ImagePaster extends AbstractPaster
    stringForInput: ->
      @alternative_text = @examineAlternativeText()
      return null if @alternative_text == null # Cancel!

      @identifier = @examineIdentifier()
      return null if @identifier == null # Cancel!

      @file_field       = @$newNestedFields.find(':input[id$="_file"]')
      @previewContainer = @$newNestedFields.find('.thumbnail')
      @previewImage     = @previewContainer.find('img')

      @file_field.val(@pastedData.dataURL)                             # Set blob string to textarea
      @previewImage.attr('src', URL.createObjectURL(@pastedData.blob)) # Set image preview
      @previewContainer.toggle()                                       # Show the image preview
      @file_field.toggle()                                             # Hide the textarea
      @identifier_field.val(@identifier)

      return "![#{@alternative_text}](@image-#{@identifier})"

    nestedFieldsIdentifier: ->
      return '#images'

    examineAlternativeText: ->
      prompt(@$input.data('pastable-image-alt-prompt'))

    examineIdentifier: ->
      identifier = prompt(@$input.data('pastable-image-identifier-prompt'), @slugify(@alternative_text))

      if identifier == ''
        @identifier_field.attr('id').match(/_(\d+)_identifier$/)[1]
      else
        identifier

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

    @$input.pastableTextarea() # TODO: Do something that can be tested using Capybara to make sure that at least the initialisation of stuff works!

    @$input.on('pasteImage', (ev, pastedData) =>
      new ImagePaster(@$input, pastedData)
    ).on 'pasteText', (ev, pastedData) ->
      console.log 'text!!!'