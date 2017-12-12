class AutocompleteInput < StringInput
  def input_type
    :text
  end
  
  def collection
    options[:collection]
  end
  
  def input(wrapper_options)
    help_blocks = []

    help_blocks << template.content_tag(:span, nil, class: 'fa fa-reorder') + ' ' + t('simple_form.inputs.autocomplete.help')

    if help_blocks.any?
      help_block = template.content_tag(:p, class: 'help-block help-block-small') do
        help_blocks.join(' ').html_safe
      end
    end

    associated_object = object.send(attribute_name)
    value = nil
    
    filter_id = 'page_parent_id_filter' # TODO: Ausprogrammieren!
    super(wrapper_options.merge(value: value, name: nil, id: filter_id)) + template.content_tag(:span, nil, class: [:fa, :arrow]) + autocomplete_collection + help_block
  end
  
  def autocomplete_collection
    # TODO: include_blank option! At the time being, only with esc key it is possible to reset to no option!
    template.content_tag :div, class: 'relative-wrapper' do
      @builder.association(attribute_name, as: :radio_buttons, label: t('simple_form.inputs.autocomplete.options_for', attribute: label_translation), collection: collection, label_method: options[:label_method], wrapper_html: {hidden: true})
    end
  end
  
  def options
    adg_options = {
      numberInTotalText:  t('simple_form.inputs.autocomplete.number_in_total'),
      numberFilteredText: t('simple_form.inputs.autocomplete.number_filtered')
    }
    merge_wrapper_options(super, wrapper_html: {data: {'adg-autocomplete': adg_options.to_json}})
  end
end