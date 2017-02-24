# encoding: utf-8

class AvatarUploader < ImageUploader
  version :medium do
    process resize_to_fill: [800, 800]
  end
end
