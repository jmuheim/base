# See http://stackoverflow.com/questions/30018652/slim-template-doesnt-render-markdown-stored-in-a-variable
module MarkdownHelper
  # TODO: Would be great to use the Tilt default mechanism instead!
  def markdown(string)
    string ||= '' # If nil is supplied, Pandoc waits for input and nothing is returned
    PandocRuby.convert(string, to: :html).strip.html_safe
  end

  def indent_heading_level(markdown, heading_level)
    markdown.to_s.lines.map do |line|
      line.gsub /^#/, '#' * (heading_level + 1)
    end.join
  end

  def pandoc_version
    matches = `pandoc -v`.match /\bpandoc (\d+\.\d+)\b/
    matches[1]
  end
end
