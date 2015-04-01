# Form errors accessibilizer.
#
# Searches for Twitter Bootstrap form groups (`.form-group`) with errors (`.has-error`) and describes the invalid inputs with their individual help blocks (`.help-block`) using `aria-describedby`.
#
# Also sets the focus to the first invalid input.
class App.FormErrorsAccessibilizer
  class FormGroup
    constructor: (formGroup) ->
      $formGroup = $(formGroup)

      @input = $formGroup.find(':input')
      @help  = $formGroup.find('.help-block')

  constructor: (el) ->
    @$el = $(el)
    formGroups = @prepareFormGroups(@$el)
    
    if formGroups.length > 0
      @describeInputsWithHelpBlocks(formGroups)
      formGroups[0].input.focus() # Set focus to first input

  prepareFormGroups: ($el) ->
    $el.find('.form-group.has-error').map (key, formGroup) ->
      new FormGroup(formGroup)

  describeInputsWithHelpBlocks: (formGroups) ->
    for formGroup in formGroups
      input_id = formGroup.input.attr('id')
      help_id  = "#{input_id}_help"

      formGroup.help.attr('id', "#{input_id}_help")
      formGroup.input.attr('aria-describedby', help_id)
