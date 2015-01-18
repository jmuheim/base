module AccordionHelper
  def accordion(title, &block)
    Accordion.new(title, self, block).render
  end

  class Accordion < Struct.new(:title, :view, :callback)
    delegate :content_tag, to: :view

    def render
      content_tag :section do
        content_tag(:h2, title) +
        content_tag(:div, id: id, role: 'tablist', 'aria-multiselectable' => true) do
          view.capture(self, &callback)
        end
      end
    end

    def item(title, &block)
      item_id = title.slugify

      content_tag(:h3, id: item_id,
                       'data-toggle' => 'collapse',
                       'data-parent' => "##{id}",
                       href: "##{item_id}_collapse",
                       'aria-expanded' => false,
                       'aria-controls' => "#{id}_collapse",
                       role: 'tab') do
        view.fa_icon('plus-square-o') + title
      end +
      content_tag(:div, id: "#{item_id}_collapse", class: 'collapse', role: 'tabpanel', 'aria-labelledby' => item_id) do
        view.capture(self, &block)
      end
    end

    private

    def id
      title.slugify
    end
  end
end
