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

    filter_id = "#{object.model_name.to_s.underscore}_#{label_target}_id_filter"
    super(wrapper_options.merge(value: value, name: nil, id: filter_id)) + template.content_tag(:span, nil, class: [:fa, :arrow]) + autocomplete_collection + help_block
  end

  def autocomplete_collection
    collection_options = {
      as: :radio_buttons,
      label: t('simple_form.inputs.autocomplete.options_for', attribute: label_translation),
      collection: collection,
      wrapper_html: {hidden: true}
    }

    collection_options[:label_method] = options[:label_method] if options[:label_method]

    # TODO: include_blank option! At the time being, only with esc key it is possible to reset to no option!
    # if options[:label_method]
    #   collection_options[:collection] = if options[:include_blank]
    #                                       blank_option = Object.new
    #                                       blank_option.define_singleton_method collection_options[:label_method] do
    #                                          I18n.t('simple_form.inputs.autocomplete.number_in_total')
    #                                        end
    #
    #                                       [blank_option] + collection
    #                                     else
    #                                       collection
    #                                     end
    # end

    template.content_tag :div, class: 'relative-wrapper' do
      @builder.association(attribute_name, collection_options)
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
