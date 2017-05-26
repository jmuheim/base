class TextFullscreenWithPastableResourcesInput < TextFullscreenInput
  def input(wrapper_options)
    super wrapper_options.merge(
      'data-pastable-image'                   => true,
      'data-pastable-image-alt-prompt'        => t('simple_form.inputs.text_fullscreen_with_pastable_resources.alt_prompt'),
      'data-pastable-image-identifier-prompt' => t('simple_form.inputs.text_fullscreen_with_pastable_resources.identifier_prompt')
    )

  end
end
