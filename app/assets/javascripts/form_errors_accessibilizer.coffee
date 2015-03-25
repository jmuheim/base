class App.FormErrorsAccessibilizer
  constructor: (el) ->
    @$el = $(el) # Always pass an element to the constructor and make it available as a jQuery selector!
    @formGroups = @$el.find('.form-group.has-error')

    if @formGroups.size() > 0
      @describe_inputs_with_help_blocks()
      @focus_first_input_with_help_block()

  describe_inputs_with_help_blocks: ->
    for formGroup in @formGroups
      $formGroup = $(formGroup)

      $help  = $formGroup.find('.help-block')
      $input = $formGroup.find(':input')

      input_id = $input.attr('id')
      help_id  = "#{input_id}_help"

      $help.attr('id', help_id)
      $input.attr('aria-describedby', help_id)

  focus_first_input_with_help_block: ->
    @formGroups.first().find(':input').focus()
