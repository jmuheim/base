class DatePickerInput < SimpleForm::Inputs::StringInput
  def input(wrapper_options)
    template.content_tag(:div, super, class: 'bfh-datepicker')
  end
end
