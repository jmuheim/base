module CarouselHelper
  def carousel(id, images)
    content_tag :div, id: id, class: ['carousel', 'slide'], data: {ride: 'carousel', interval: 7500} do
      carousel_indicators(id, images) +
      carousel_inner(images) +
      carousel_control_left(id) +
      carousel_control_right(id)
    end
  end

  def carousel_indicators(id, images)
    content_tag :ol, class: 'carousel-indicators' do
      images.each_with_index.map do |image, i|
        content_tag :li, nil, class: (i == 0 ? 'active' : nil), data: {slide_to: i, target: "##{id}"}
      end.join.html_safe
    end
  end

  def carousel_inner(images)
    content_tag :div, class: 'carousel-inner' do
      images.each_with_index.map do |image, i|
        content_tag :div, class: "item #{i == 0 ? 'active' : nil}", style: "background-image: url(#{image_path(image.first)})" do
          image_tag(image.first, alt: image.last) + content_tag(:p, image.last)
        end
      end.join.html_safe
    end
  end

  def carousel_control_left(id)
    content_tag :a, class: ['left', 'carousel-control'], data: {slide: 'prev'}, href: "##{id}", role: 'button' do
      content_tag :span, nil, class: ['glyphicon', 'glyphicon-chevron-left']
    end
  end

  def carousel_control_right(id)
    content_tag :a, class: ['right', 'carousel-control'], data: {slide: 'next'}, href: "##{id}", role: 'button' do
      content_tag :span, nil, class: ['glyphicon', 'glyphicon-chevron-right']
    end
  end
end
