class StringInput < SimpleForm::Inputs::StringInput
  def input(wrapper_options)
    help_blocks = []

    if object.respond_to?(:translated_attribute_names) && object.translated_attribute_names.include?(attribute_name.to_s)
      help_blocks << template.content_tag(:span, nil, class: 'fa fa-globe') + ' ' + t('simple_form.inputs.better_text.multi_language')
    end

    if help_blocks.any?
      help_block = template.content_tag(:p, class: 'help-block help-block-small') do
        help_blocks.join(' ').html_safe
      end
    end

    super(wrapper_options) + help_block
  end
end