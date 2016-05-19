# encoding: utf-8

class ImageUploader < AbstractUploader
  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
