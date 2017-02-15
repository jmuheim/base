# encoding: utf-8

class ImageUploader < AbstractUploader
  def extension_whitelist
    %w(jpg jpeg gif png)
  end
end
