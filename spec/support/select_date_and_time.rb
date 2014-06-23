module SelectDateAndTime
  def select_by_id(id, options = {})
    field = options[:from]
    option_xpath = "//*[@id='#{field}']/option[#{id}]"
    option_text = find(:xpath, option_xpath).text
    select option_text, from: field
  end

  def select_date(date, options = {})
    field = options[:from]

    select date.year.to_s,   from: "#{field}_1i"
    select_by_id date.month, from: "#{field}_2i"
    select date.day.to_s,    from: "#{field}_3i"
  end

  def select_datetime(datetime, options = {})
    select_date(datetime, options)

    field = options[:from]

    select datetime.hour.to_s,      from: "#{field}_4i"
    select_by_id datetime.min.to_s, from: "#{field}_5i"
  end
end
