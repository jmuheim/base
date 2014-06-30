class UploadInput < SimpleForm::Inputs::FileInput
  def input
    input_cache + fileinput + remove_checkbox
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
      template.content_tag :div, class: 'checkbox' do
        @builder.input_field(field_name, as: :boolean) + @builder.label(field_name, label: I18n.t('simple_form.remove_file'))
      end
    end
  end

  def fileinput
    template.content_tag :div, class: ['fileinput', 'fileinput-new'], data: {provides: 'fileinput'} do
      fileinput_new + fileinput_preview + btn_remove + btn_file
    end
  end

  def fileinput_new
    template.content_tag :div, class: ['fileinput-new', 'thumbnail'], data: {trigger: 'fileinput'} do
      if file_available?
        template.image_tag object.send(attribute_name)
      else
        template.fa_icon(:user)
      end
    end
  end

  def fileinput_preview
    template.content_tag :div, nil, class: ['fileinput-preview', 'fileinput-exists', 'thumbnail'], data: {trigger: 'fileinput'}
  end

  def btn_file
    template.content_tag :div do
      template.content_tag :span, class: ['btn', 'btn-default', 'btn-file'] do
        template.content_tag(:span, I18n.t('simple_form.select_file'), class: 'fileinput-new') +
          template.content_tag(:span, I18n.t('simple_form.change_file'), class: 'fileinput-exists') +
          @builder.input_field(attribute_name, as: :file)
      end
    end
  end

  def btn_remove
    template.content_tag :a, href: '#', class: ['btn', 'btn-default', 'fileinput-exists'], data: {dismiss: 'fileinput'} do
      template.icon 'remove-circle', I18n.t('simple_form.reset_selection')
    end
  end
end
