class TextFullscreenInput < SimpleForm::Inputs::TextInput
  def input(wrapper_options)
    super wrapper_options.merge 'data-textarea-fullscreenizer' => true,
      'data-textarea-fullscreenizer-toggler-text' => I18n.t('simple_form.inputs.text_fullscreen.toggler_text')

  end
end
