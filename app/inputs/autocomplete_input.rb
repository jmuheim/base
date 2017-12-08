class AutocompleteInput < StringInput
  def input_type
    :text
  end
  
  def input(wrapper_options)
    help_blocks = []

    help_blocks << template.content_tag(:span, nil, class: 'fa fa-reorder') + ' ' + t('simple_form.inputs.autocomplete.help')

    if help_blocks.any?
      help_block = template.content_tag(:p, class: 'help-block help-block-small') do
        help_blocks.join(' ').html_safe
      end
    end

    super(wrapper_options) + autocomplete_collection + help_block
  end
  
  def autocomplete_collection
    @builder.input(attribute_name, as: :radio_buttons, label: t('simple_form.inputs.autocomplete.suggestions_for', attribute: label_translation))
  end
end