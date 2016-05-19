# encoding: utf-8

class AvatarUploader < ImageUploader
  version :thumb do
    process resize_to_fill: [50, 50]
  end

  version :medium do
    process resize_to_fill: [800, 800]
  end
end
