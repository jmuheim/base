# See http://stackoverflow.com/questions/30018652/slim-template-doesnt-render-markdown-stored-in-a-variable
module MarkdownHelper
  def markdown(string)
    rc = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
    rc.render(string.to_s).html_safe
  end
end
