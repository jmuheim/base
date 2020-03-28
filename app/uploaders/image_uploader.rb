# encoding: utf-8

class ImageUploader < AbstractUploader
  after :store, :optimise_images

  version :thumb do
    process resize_to_fill: [50, 50]
  end

  def extension_whitelist
    %w(jpg jpeg gif png)
  end

  # This is provided because it's not easily possible to add a border around docx exported images (see https://github.com/jgm/pandoc/issues/3043).
  version :print do
    process border: ['black']
  end

  # Optimise PNG files to save disk space (see https://stackoverflow.com/questions/60622916).
  def optimise_images(new_file)
    return if Rails.env.test? # Optimising consumes quite some time, so let's disable it for tests

    if version_name.nil?
      image_optim = ImageOptim.new allow_lossy: true,
                                   pngout: false, # Need to suppress this, otherwise we get errors (see https://github.com/toy/image_optim_pack/issues/19)
                                   svgo: false # Dito
      image_optim.optimize_images!(Dir["#{File.dirname(file.file)}/*.png"])
    end
  end
end
