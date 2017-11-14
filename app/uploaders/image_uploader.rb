# encoding: utf-8

class ImageUploader < AbstractUploader
  version :thumb do
    process resize_to_fill: [50, 50]
  end

  def extension_whitelist
    %w(jpg jpeg gif png)
  end

  version :print do
    process resize_to_limit: [800, 600]
    process border: ['black']
  end
end
