# , input_html: {data: {behaviour: 'datepicker'}}

class DatePickerInput < SimpleForm::Inputs::StringInput
  def input_html_options
    super.merge data: {behaviour: 'datepicker'}
  end

  def input(wrapper_options)
    template.content_tag(:div, super + addon, class: 'input-group date')
  end

  def addon
    template.content_tag(:span, class: 'input-group-addon') do
      template.content_tag(:i, nil, class: 'glyphicon glyphicon-calendar')
    end
  end
end
