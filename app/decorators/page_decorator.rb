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
        caption = $1
        url     = $2
        type    = $3
        id      = $4
        data    = []

        case type
        when 'page'
          if page = Page.find_by_id(id)
            data << ".#{type}"
            url = h.page_path(page)

            if caption.empty?
              caption = page.title
            elsif caption != page.title
              data << "title=\"#{page.title}\""
            end
          end
        when 'image'
          if image = images.find_by_identifier(id)
            data << ".#{type}"
            url = image.file.url
          end
        when 'code'
          if code = codes.find_by_identifier(id)
            data << ".#{type}"

            if caption.empty?
              caption = code.title
            elsif caption != code.title
              data << "title=\"#{code.title}\""
            end

            # TODO: Adding the thumbnail only works well in block links! Inline links should have a font awesome code icon instead.
            caption = "**#{caption}**![](#{code.thumbnail_url})"

            url = code.pen_url
          end
        end

        data_string = data.empty? ? nil : "{#{data.join ' '}}"
        "[#{caption}](#{url})#{data_string}"
      end

      line
    end.join
  end
end