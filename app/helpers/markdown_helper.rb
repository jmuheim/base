# See http://stackoverflow.com/questions/30018652/slim-template-doesnt-render-markdown-stored-in-a-variable
module MarkdownHelper
  # TODO: Would be great to use the Tilt default mechanism instead!
  def markdown(string)
    string ||= '' # If nil is supplied, Pandoc waits for input and nothing is returned
    PandocRuby.convert(string, to: :html).strip.html_safe
  end

  def complete_internal_references(markdown)
    markdown.to_s.lines.map do |line|
      line.gsub!(/\[(.*?)\]\((@(.+?)-(.+?))\)/) do
        text = $1
        url  = $2
        type = $3
        id   = $4
        data = nil

        case type
        when 'page'
          if page = Page.find_by_id(id)
            url = page_path(page)

            if text.empty?
              text = page.title
            elsif text != page.title
              data = "{title=\"#{page.title}\"}"
            end
          end
        when 'image'
          if image = Image.find_by_identifier(id)
            url = image.file.url
          end
        end

        "[#{text}](#{url})#{data}"
      end

      line
    end.join
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
