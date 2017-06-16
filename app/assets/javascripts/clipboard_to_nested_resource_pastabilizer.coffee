# Allows pasting of clipboard to nested resources.
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
      @identifierField = @$newNestedFields.find(':input[id$="_identifier"]')

    getTemporaryIdentifierId: ->
      @identifierField.attr('id').match(/_(\d+)_identifier$/)[1]

    # TODO: This breaks the undo/redo history in Chrome and Safari (FF and IE seem to work)!
    #
    # More info:
    #
    # - https://stackoverflow.com/questions/7553430/javascript-textarea-undo-redo/10345596#10345596
    # - https://stackoverflow.com/questions/16195644/in-chrome-undo-does-not-work-properly-for-input-element-after-contents-changed-p
    # - http://jsfiddle.net/rudiedirkx/k4spa0dv/
    insertStringIntoInput: (string) ->
      caretPosition = @$input.caret()

      valueBefore = @$input.val().substring(0, caretPosition)
      valueAfter  = @$input.val().substring(caretPosition)

      @$input.val(valueBefore + string + valueAfter)
      @$input.caret(caretPosition + string.length)

    nestedFieldsIdentifier: ->
      throw ("Implement in sub class!")
      # In sub class, return ID of nested fields container, e.g. '#images'!

    stringForInput: ->
      throw ("Implement in sub class!")
      # In sub class, return string for inserting into input! In addition, you can do other stuff, e.g. displaying a pasted image.

  class ImagePaster extends AbstractPaster
    nestedFieldsIdentifier: ->
      '#images'

    examineAlternativeText: ->
      prompt(@$input.data('pastable-resources-image-alt-prompt'))

    examineIdentifier: ->
      identifier = prompt(@$input.data('pastable-resources-image-identifier-prompt'), @slugify(@alternativeText))

      if identifier == ''
        @getTemporaryIdentifierId()
      else
        identifier

    # https://gist.github.com/mathewbyrne/1280286
    slugify: (text) ->
      text.toString().toLowerCase().replace(/\s+/g, '-').replace(/[^\w\-]+/g, '').replace(/\-\-+/g, '-').replace(/^-+/, '').replace /-+$/, ''

    stringForInput: ->
      @alternativeText = @examineAlternativeText()
      return null if @alternativeText == null # Cancel!

      @identifier = @examineIdentifier()
      return null if @identifier == null # Cancel!

      @fileField       = @$newNestedFields.find(':input[id$="_file"]')
      @previewContainer = @$newNestedFields.find('.thumbnail')
      @previewImage     = @previewContainer.find('img')

      @fileField.val(@pastedData.dataURL)                             # Set blob string to textarea
      @previewImage.attr('src', URL.createObjectURL(@pastedData.blob)) # Set image preview
      @previewContainer.toggle()                                       # Show the image preview
      @fileField.toggle()                                             # Hide the textarea
      @identifierField.val(@identifier)

      "![#{@alternativeText}](@image-#{@identifier})"

  class CodePaster extends AbstractPaster
    nestedFieldsIdentifier: ->
      '#codes'

    examineAlternativeText: ->
      prompt(@$input.data('pastable-resources-code-text-prompt'))

    stringForInput: ->
      @alternativeText = @examineAlternativeText()
      return null if @alternativeText == null # Cancel!

      codeUser        = @pastedData[1]
      codePen         = @pastedData[2]
      codeIdentifier  = "#{codeUser}-#{codePen}"

      @identifierField.val codeIdentifier

      "[#{@alternativeText}](@code-#{codeIdentifier})"

  constructor: (el) ->
    @$input = $(el)

    @$input.pastableTextarea()

    @$input.on('pasteImage', (ev, pastedData) =>
      new ImagePaster(@$input, pastedData)
    ).on('pasteText', (ev, pastedData) =>
      if match = pastedData.text.match(/https:\/\/codepen.io\/(.+)\/pen\/(.+)/)
        new CodePaster(@$input, match)

        # Doesn't work at the time being, see https://github.com/layerssss/paste.js/issues/45
        ev.preventDefault()

        # ...so we need this workaround:
        caretPosition = @$input.caret()
        @$input.val(@$input.val().replace(pastedData.text, ''))
        @$input.caret(caretPosition - pastedData.text.length)
    )