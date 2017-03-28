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

  def diff(before, after)
    if before.lines.count > 1 || after.lines.count > 1 # Text
      content_tag :form, method: :post, action: "http://www.textdiff.com/" do
        before = content_tag :input, nil, type: "hidden", name: "string1", value: before
        after  = content_tag :input, nil, type: "hidden", name: "string2", value: after
        button = content_tag :button, 'Diff', class: "btn btn-xs btn-warning", type: "submit"

        (before + after + button).html_safe
      end
    elsif before.split.count > 1 || after.split.count > 1 # Words
      h Differ.diff_by_word(before, after.to_s).format_as(:html).html_safe
    else
      h Differ.diff_by_char(before, after.to_s).format_as(:html).html_safe
    end
  end
end
