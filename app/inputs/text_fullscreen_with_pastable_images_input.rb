class TextFullscreenWithPastableImagesInput < TextFullscreenInput
  def input(wrapper_options)
    super wrapper_options.merge(
      'data-pastable-image'                   => true,
      'data-pastable-image-alt-prompt'        => t('simple_form.inputs.text_fullscreen_with_pastable_images.alt_prompt'),
      'data-pastable-image-identifier-prompt' => t('simple_form.inputs.text_fullscreen_with_pastable_images.identifier_prompt')
    )

  end
end
