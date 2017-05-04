# See http://stackoverflow.com/questions/43225314/rails-atom-feed-how-to-add-html-tags-like-h1-to-the-feed-content
atom_feed do |feed|
  feed.title "#{Page.model_name.human(count: :other)} - #{t('app.name')}"
  feed.updated(@pages[0].created_at) if @pages.length > 0

  @pages.each do |page|
    feed.entry(page) do |entry|
      entry.title(page.title)

      entry.author do |author|
        author.name(page.creator.name)
        author.uri(user_path(page.creator))
      end

      entry.summary(markdown page.lead_with_references)

      entry.content(render(page), type: 'html')
    end
  end
end