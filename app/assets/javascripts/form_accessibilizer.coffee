# Form errors accessibilizer.
#
# Searches for Twitter Bootstrap form groups (`.form-group`) and describes the inputs with their individual help blocks (`.help-block`) using `aria-describedby`.
#
# Also sets the focus to the first invalid input.
class App.FormAccessibilizer
  class FormGroup
    constructor: (formGroup) ->
      $formGroup = $(formGroup)

      @input    = $formGroup.find(':input')
      @helps    = $formGroup.find('.help-block')
      @hasError = $formGroup.hasClass('has-error')

  constructor: (el) ->
    @$el = $(el)
    formGroups = @prepareFormGroups(@$el)

    @describeInputsWithHelpBlocks(formGroups)
    @setFocusToFirstInvalidInput(formGroups)

  prepareFormGroups: ($el) ->
    $el.find('.form-group').map (key, formGroup) ->
      new FormGroup(formGroup)

  describeInputsWithHelpBlocks: (formGroups) ->
    for formGroup in formGroups
      input_id = formGroup.input.attr('id')
      help_ids = []

      # Map would be nice, but map with index doesn't seem to work: https://gist.github.com/josephwlh/10799362
      for help, i in formGroup.helps
        id_parts = [input_id, 'help']
        id_parts.push(i + 1) if formGroup.helps.length > 1 # Add a counter if there is more than one help block
        id = id_parts.join '_'

        $(help).attr('id', id)
        help_ids.push id

      if help_ids.length > 0
        formGroup.input.attr('aria-describedby', help_ids.join(' '))

  setFocusToFirstInvalidInput: (formGroups) ->
    for formGroup in formGroups
      if formGroup.hasError
        formGroup.input.focus() # Set focus to first input
        break
