require 'mini_magick'

module CarrierWave
  module MiniMagick
    # Inspired by https://gist.github.com/artemave/c20e7450af866f5e7735
    def border(color)
      manipulate! do |img|
        img.format 'png'

        overlay = ::MiniMagick::Image.open img.path
        overlay.format 'png'

        overlay.combine_options do |o|
          o.alpha 'transparent'
          o.background 'none'
          o.fill 'none'
          o.stroke color
          o.strokewidth 1
          o.draw 'rectangle 0,0,%s,%s' % [img[:width] - 1, img[:height] - 1]
        end

        img.composite(overlay, 'png') do |i|
          i.compose 'Over'
        end
      end
    end

    # https://github.com/carrierwaveuploader/carrierwave/wiki/How-to%3A-Specify-the-image-quality
    def quality(percentage)
      manipulate! do |img|
        img.quality(percentage.to_s)
        img = yield(img) if block_given?
        img
      end
    end
  end
end
