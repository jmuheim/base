class TextFullscreenWithPastableImagesInput < SimpleForm::Inputs::TextFullscreenInput
  def input(wrapper_options)
    super wrapper_options.merge(
      'data-pasteable-image'                   => true,
      'data-pasteable-image-alt-prompt'        => t('simple_form.inputs.text_fullscreen_with_pastable_images.alt_prompt'),
      'data-pasteable-image-identifier-prompt' => t('simple_form.inputs.text_fullscreen_with_pastable_images.identifier_prompt')
    )

  end
end
