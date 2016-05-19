# This is officially the ugliest thing in the whole app... ;-)
class UploadInput < SimpleForm::Inputs::FileInput
  def input(wrapper_options)
    input_cache + input_real(provides: 'fileinput')
  end

  def input_preview
    template.content_tag :div, title: I18n.t('simple_form.inputs.upload.click_to_choose_another_file', attribute: label_text), data: {placement: 'right'} do # We need another div around the whole thing, otherwise Bootstrap tooltip doesn't seem to work! See http://stackoverflow.com/questions/24497353/bootstrap-tooltip-isnt-shown-on-a-specific-element-but-it-seems-to-be-applied
      template.content_tag :div, nil, class: ['fileinput-preview', 'fileinput-exists', 'thumbnail'], data: {trigger: 'fileinput'}
    end
  end

  # TODO: There is no spec for displaying these icons yet (as we have no uploaders other than image uploaders in our models)
  def icon_for(extension)
    if ['zip', 'rar', '7z', '7zip', 'gzip'].include? extension
      'file-archive-o'
    elsif ['mp3', 'wav'].include? extension
      'file-audio-o'
    elsif ['html', 'css', 'php', 'c', 'js', 'rb'].include? extension
      'file-code-o'
    elsif ['xls', 'xlsx'].include? extension
      'file-excel-o'
    elsif ['xls', 'xlsx'].include? extension
      'file-image-o'
    elsif ['pdf'].include? extension
      'file-pdf-o'
    elsif ['ppt', 'pptx'].include? extension
      'file-powerpoint-o'
    elsif ['mp4', 'divx', 'avi', 'xvid'].include? extension
      'file-video-o'
    elsif ['doc', 'docx'].include? extension
      'file-word-o'
    else
      'file-o'
    end
  end

  def real_input_new
    template.content_tag :div, title: I18n.t('simple_form.inputs.upload.click_to_choose_a_file', attribute: label_text), data: {placement: 'right'} do # We need another div around the whole thing, otherwise Bootstrap tooltip doesn't seem to work! See http://stackoverflow.com/questions/24497353/bootstrap-tooltip-isnt-shown-on-a-specific-element-but-it-seems-to-be-applied
      template.content_tag :a, href: '#', class: ['fileinput-new', 'thumbnail'], data: {trigger: 'fileinput'} do
        if file_available?
          if ['jpg', 'jpeg', 'gif', 'png'].include? object.send(attribute_name).file.extension
            template.image_tag(object.send(attribute_name), alt: I18n.t('simple_form.inputs.upload.file_preview'))
          else
            template.icon(icon_for(object.send(attribute_name).file.extension), type: :fa) + ' ' + object.send(attribute_name).file.filename
          end
        else
          template.icon(:upload, type: :fa)
        end + content_tag(:span, I18n.t('simple_form.inputs.upload.click_to_choose_a_file', attribute: label_text), class: 'sr-only')
      end
    end
  end

  def input_real(data = {})
    template.content_tag :div, class: ['fileinput', 'fileinput-new'], data: data do
      real_input_new + input_preview + btn_remove + btn_file + remove_checkbox
    end
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
        @builder.check_box(field_name) + @builder.label(field_name, label: I18n.t('simple_form.inputs.upload.remove_file', attribute: label_text))
      end
    end
  end

  def btn_file
    template.content_tag :div, class: 'btn-file' do
      @builder.input_field(attribute_name, as: :file, tabindex: -1)
    end
  end

  def btn_remove
    template.content_tag :a, href: '#', class: ['btn', 'btn-default', 'fileinput-exists'], data: {dismiss: 'fileinput', placement: 'right'}, title: I18n.t('simple_form.inputs.upload.reset_selection', attribute: label_text) do
      template.icon 'remove-circle'
    end
  end
end
