# See http://stackoverflow.com/questions/30018652/slim-template-doesnt-render-markdown-stored-in-a-variable
module MarkdownHelper
  # TODO: Would be great to use the Tilt default mechanism instead!
  def markdown(string)
    string ||= '' # If nil is supplied, Pandoc waits for input and nothing is returned
    html = PandocRuby.convert(string, PANDOC_OPTIONS).strip
    
    nokogiri = Nokogiri::HTML::DocumentFragment.parse(html)

    nokogiri = clone_alt_into_img_and_hide_figcaption_from_sr(nokogiri)
    nokogiri = add_empty_alt_to_decorative_img(nokogiri)

    nokogiri.to_html.html_safe
  end

  # Pandoc removes the content of an image's alt attribute, as the text is also available inside figcaption (to avoid screen reader redundancies). This is terrible though, as this renders the image itself invisible to screen readers. So we clone the alternative text back into the alt attribute again, and place an aria-hidden on figcaption.
  #
  # See https://github.com/jgm/pandoc/issues/6491
  def clone_alt_into_img_and_hide_figcaption_from_sr(nokogiri)
    nokogiri.css('figure').map do |figure|
      img        = figure.at_css('img')
      figcaption = figure.at_css('figcaption')

      img['alt'] = figcaption.text
      figcaption['aria-hidden'] = true
    end

    nokogiri
  end

  # Pandoc doesn't add an empty alt-attribute if the alternative text is left empty. Because screen readers announce the file name in this situation, we add an empty alt-attribute here.
  def add_empty_alt_to_decorative_img(nokogiri)
    nokogiri.css('img:not([alt])').map do |img|
      img['alt'] = ''
    end

    nokogiri
  end

  def indent_heading_level(markdown, heading_level, visual_heading_level = nil)
    markdown.to_s.lines.map do |line|
      line = line.rstrip # Remove all new line stuff (\n, \r)

      if matches = line.match(/^([#]+)(.*)$/)
        hashes  = matches[1] + '#' * (heading_level)
        text    = matches[2]
        klass   = visual_heading_level ? ".h#{visual_heading_level + matches[1].size - 1}" : nil
        role    = hashes.size > 6 ? "role=\"heading\" aria-level=\"#{hashes.size}\"" : nil
        newline = matches[3]

        attributes = [klass, role].compact.any? ? "{#{klass} #{role}}" : nil

        line = "#{hashes}#{text}#{attributes}#{newline}"
      end

      line
    end.join "\n"
  end
end
