# See http://stackoverflow.com/questions/43225314/rails-atom-feed-how-to-add-html-tags-like-h1-to-the-feed-content
atom_feed do |feed|
  feed.title "#{Page.model_name.human(count: :other)} - #{t('app.name')}"
  feed.updated(@pages[0].created_at) if @pages.length > 0

  @pages.each do |page|
    feed.entry(page) do |entry|
      entry.title(page.title)
      entry.content(type: 'html') do |html|
        html.h1 t('.position_in_hierarchy')
        html.p ([page] + page.ancestors).reverse.map(&:title).join ': '

        html.h1 Page.human_attribute_name :lead
        html.div markdown indent_heading_level(page.lead_with_references, 1)

        html.h1 Page.human_attribute_name :content
        html.div markdown indent_heading_level(page.content_with_references, 1)

        html.h1 t('.atom_notice_title')
        html.p t('.atom_notice_content', version: page.versions.count, date: l(page.updated_at, format: :long))
      end
    end
  end
end