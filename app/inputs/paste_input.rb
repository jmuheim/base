class PasteInput < UploadInput
  def input(wrapper_options)
    input_cache + input_real(paste: true)
  end

  def input_preview
    template.content_tag :div, title: I18n.t('simple_form.inputs.paste.click_to_paste_another_image', attribute: label_text), data: {placement: 'right'} do # We need another div around the whole thing, otherwise Bootstrap tooltip doesn't seem to work! See http://stackoverflow.com/questions/24497353/bootstrap-tooltip-isnt-shown-on-a-specific-element-but-it-seems-to-be-applied
      template.content_tag :a, href: '#', class: ['fileinput-new', 'thumbnail'], style: ('display: none' unless file_available?) do
        template.image_tag(object.send(attribute_name), alt: I18n.t('simple_form.inputs.paste.image_preview')) + content_tag(:span, I18n.t('simple_form.inputs.paste.click_to_paste_another_image', attribute: label_text), class: 'sr-only')
      end
    end
  end

  def real_input_new
    options = { as:          'text',
                class:       'form-control',
                maxlength:   -1, # Ugly, see https://github.com/carrierwaveuploader/carrierwave/issues/1851
                placeholder: I18n.t('simple_form.inputs.paste.paste_here'),
                rows:        1
              }

    options[:style] = 'display: none' if file_available?

    @builder.input_field(attribute_name, options)
  end

  # This is ugly... I know.
  def btn_file; end
  def btn_remove; end
end
