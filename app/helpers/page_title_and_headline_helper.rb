module PageTitleAndHeadlineHelper
  def headline
    @headline or raise 'No page heading provided! Be sure to call #headline_with_flash first.'
  end

  def headline_with_flash(*args)
    options = args.extract_options!
    heading = args[0]
    raise "You can't provide both a heading and options!" if heading && options.any?

    @headline = heading.nil? ? default_headline(options) : heading

    content_tag :div, class: 'headline' do
      content_tag(:h1, @headline) + render(partial: 'layouts/messages')
    end
  end

  def title_tag
    content_tag :title do
      parts = []
      parts += flash.map { |key, value| "#{t "flash.#{key}"}: #{value}" } if flash.any?
      parts << headline
      parts << "- #{t('app.name')}" unless current_page?(root_path)
      parts.join ' '
    end
  end

  def default_headline(options = {})
    t '.title', options
  end
end