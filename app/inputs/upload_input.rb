class UploadInput < SimpleForm::Inputs::FileInput
  def input(wrapper_options)
    input_cache + file_input
  end

  def file_available?
    object.send("#{attribute_name}?")
  end

  def input_cache
    field_name = "#{attribute_name}_cache"
    @builder.input_field field_name, as: :hidden, value: object.send(field_name)
  end

  def remove_checkbox
    if file_available?
      field_name = "remove_#{attribute_name}"
      template.content_tag :div, class: ['checkbox', 'remove_file'] do
        @builder.check_box(field_name) + @builder.label(field_name, label: I18n.t('simple_form.remove_file', attribute: label_text))
      end
    end
  end

  def file_input
    template.content_tag :div, class: ['fileinput', 'fileinput-new'], data: {provides: 'fileinput'} do
      file_input_new + input_preview + btn_remove + btn_file + remove_checkbox
    end
  end

  def file_input_new
    template.content_tag :div, title: I18n.t('simple_form.click_to_choose_a_file', attribute: label_text), data: {placement: 'right'} do # We need another div around the whole thing, otherwise Bootstrap tooltip doesn't seem to work! See http://stackoverflow.com/questions/24497353/bootstrap-tooltip-isnt-shown-on-a-specific-element-but-it-seems-to-be-applied
      template.content_tag :a, href: '#', class: ['fileinput-new', 'thumbnail'], data: {trigger: 'fileinput'} do
        if file_available?
          template.image_tag(object.send(attribute_name), alt: I18n.t('simple_form.file_preview'))
        else
          template.fa_icon(:upload)
        end + content_tag(:span, I18n.t('simple_form.click_to_choose_a_file', attribute: label_text), class: 'sr-only')
      end
    end
  end

  def input_preview
    template.content_tag :div, title: I18n.t('simple_form.select_another_file'), data: {placement: 'right'} do # We need another div around the whole thing, otherwise Bootstrap tooltip doesn't seem to work! See http://stackoverflow.com/questions/24497353/bootstrap-tooltip-isnt-shown-on-a-specific-element-but-it-seems-to-be-applied
      template.content_tag :div, nil, class: ['fileinput-preview', 'fileinput-exists', 'thumbnail'], data: {trigger: 'fileinput'}
    end
  end

  def btn_file
    template.content_tag :div, class: 'btn-file' do
      @builder.input_field(attribute_name, as: :file, tabindex: -1)
    end
  end

  def btn_remove
    template.content_tag :a, href: '#', class: ['btn', 'btn-default', 'fileinput-exists'], data: {dismiss: 'fileinput', placement: 'right'}, title: I18n.t('simple_form.reset_selection', attribute: label_text) do
      template.icon 'remove-circle'
    end
  end
end
