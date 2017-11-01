class TextInput < SimpleForm::Inputs::TextInput
  def input(wrapper_options)
    help_blocks = []

    if object.respond_to?(:textareas_accepting_pastables) && object.textareas_accepting_pastables.include?(attribute_name)
      wrapper_options.merge!(
        'data-pastable-resources'                         => true,
        'data-pastable-resources-image-alt-prompt'        => t('simple_form.inputs.better_text.image_alt_prompt'),
        'data-pastable-resources-image-identifier-prompt' => t('simple_form.inputs.better_text.image_identifier_prompt'),
        'data-pastable-resources-code-text-prompt'        => t('simple_form.inputs.better_text.code_text_prompt')
      )

      help_blocks << template.content_tag(:span, nil, class: 'fa fa-paste') + ' ' + t('simple_form.inputs.better_text.allows_pasting_of_resources')
    end

    if object.respond_to?(:translated_attribute_names) && object.translated_attribute_names.include?(attribute_name.to_s)
      help_blocks << template.content_tag(:span, nil, class: 'fa fa-globe') + ' ' + t('simple_form.inputs.better_text.multi_language')
    end

    if help_blocks.any?
      help_block = template.content_tag(:p, class: 'help-block help-block-small') do
        help_blocks.join(' ').html_safe
      end
    end

    super(wrapper_options.merge 'data-textarea-fullscreenizer' => true,
      'data-textarea-fullscreenizer-toggler-text' => I18n.t('simple_form.inputs.text_fullscreen.toggler_text'),
      rows: 5) + help_block
  end
end