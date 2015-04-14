# encoding: utf-8

class AvatarUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # We are versioning files using paper_trail
  configure do |config|
    config.remove_previously_stored_files_after_update = false
  end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "#{store_dir_prefix}/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Usually just 'uploads', but we don't want to clutter our development uploads with our spec uploads
  def store_dir_prefix
    parts = ['uploads']
    parts << 'tmp' if Rails.env.test?
    parts.join '/'
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process resize_to_fill: [800, 800]

  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  version :thumb do
    process resize_to_fill: [100, 100]
  end

  version :medium do
    process resize_to_fill: [800, 800]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  def filename
    # See http://stackoverflow.com/questions/9423279/papertrail-and-carrierwave/29583400#29583400
    [@cache_id, original_filename].join('-') if original_filename.present?
  end
end
