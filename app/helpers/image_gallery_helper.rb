module ImageGalleryHelper
  def zoomable_image(image, options = {})
    image_gallery do |gallery|
      gallery.image(image, options)
    end
  end

  def image_gallery(name = '', &block)
    if name.empty?
      yield ImageGallery.new(name)
    else
      content_tag :div, class: name do
        yield ImageGallery.new(name)
      end
    end
  end
end

class ImageGallery
  include ActionView::Helpers::AssetTagHelper
  attr_accessor :output_buffer

  def initialize(name)
    @name = name
  end

  def image(image, options = {})
    content_tag :a, href: image.url, class: 'fancybox', rel: @name do
      image_tag image.url(:thumb), options
    end
  end
end