class App.DependingSelectDisabler
  constructor: (input, context) ->
    @$input        = $(input)
    @$context      = $(context)

    @$inputOptions       = $(@$input.find('option'))
    @$inputSelectedOption = $(@$input.find(':selected'))

    @enabledValue     = @$input.attr('data-depends-value')
    @dependingInputId = @$input.attr('data-depends-id')
    @dependingInput   = @$context.find("##{@dependingInputId}")

    @addChangeListener()

  addChangeListener: ->
    self = @
    @dependingInput.change (e) ->
      if @.value == self.enabledValue
        self.$input.removeAttr('disabled')
        self.$inputOptions.appendTo(self.$input)
        self.$inputSelectedOption.prop('selected', true) # Make sure that original option is selected
      else
        self.$input.attr('disabled', 'disabled')
        self.$inputOptions.detach()
