# TODO: Now that we use the decorator pattern, we should refactor some helper methods...!
class PageDecorator < Draper::Decorator
  delegate_all

  def lead_with_references
    complete_internal_references lead
  end

  def content_with_references
    complete_internal_references content
  end

  def notes_with_references
    complete_internal_references notes
  end

  private

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
            url = h.page_path(page)

            if text.empty?
              text = page.title
            elsif text != page.title
              data = "{title=\"#{page.title}\"}"
            end
          end
        when 'image'
          if image = images.find_by_identifier(id)
            url = image.file.url
          end
        end

        "[#{text}](#{url})#{data}"
      end

      line
    end.join
  end
end