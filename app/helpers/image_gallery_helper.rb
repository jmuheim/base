module ImageGalleryHelper
  def image_gallery(name = nil, &block)
    name ||= 'gallery_' + SecureRandom.hex(6)

    content_tag :div, class: name do
      with_options gallery_name: name do |gallery|
        yield gallery
      end
    end
  end

  def zoomable_image(image, options = {})
    content_tag :a, href: image.url, class: 'fancybox', rel: options.delete(:gallery_name) do
      image_tag image.url(:thumb), options
    end
  end
end
