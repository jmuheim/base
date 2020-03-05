# encoding: utf-8

class ImageUploader < AbstractUploader
  # convert :jpg

  version :thumb do
    process resize_to_fill: [50, 50]
  end

  def extension_whitelist
    %w(jpg jpeg gif png)
  end

  # This is provided because it's not easily possible to add a border around docx exported images (see https://github.com/jgm/pandoc/issues/3043).
  version :print do
    process border: ['black']
    process quality: 80
  end
end
