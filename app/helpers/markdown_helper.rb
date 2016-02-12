# See http://stackoverflow.com/questions/30018652/slim-template-doesnt-render-markdown-stored-in-a-variable
module MarkdownHelper
  # TODO: Would be great to use the Tilt default mechanism instead!
  def markdown(string)
    PandocRuby.convert(string, to: :html).strip.html_safe
  end

  def indent_heading_level(markdown, heading_level)
    markdown.lines.map do |line|
      line.gsub /^#/, '#' * (heading_level + 1)
    end.join
  end
end
