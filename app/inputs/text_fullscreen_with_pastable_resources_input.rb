class TextFullscreenWithPastableResourcesInput < TextFullscreenInput
  def input(wrapper_options)
    super wrapper_options.merge(
      'data-pastable-resources'                         => true,
      'data-pastable-resources-image-alt-prompt'        => t('simple_form.inputs.text_fullscreen_with_pastable_resources.image_alt_prompt'),
      'data-pastable-resources-image-identifier-prompt' => t('simple_form.inputs.text_fullscreen_with_pastable_resources.image_identifier_prompt'),
      'data-pastable-resources-code-text-prompt'        => t('simple_form.inputs.text_fullscreen_with_pastable_resources.code_text_prompt')
    )

  end
end
