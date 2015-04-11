# encoding: utf-8

class AvatarUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # This seems problematic, see http://stackoverflow.com/questions/29564354/carrierwave-setting-remove-previously-stored-files-after-update-to-true-breaks
  configure do |config|
    config.remove_previously_stored_files_after_update = false # We are versioning them using paper_trail
  end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "#{self.class.store_dir_prefix}#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def self.store_dir_prefix
    prefix = 'uploads/'
    prefix = "#{Rails.root}/tmp/#{prefix}" if Rails.env.test?

    prefix
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
    process resize_to_fill: [50, 50]
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
    # A timestamp as prefix prevents overwriting existing files with the same name
    prefix = Rails.env.test? ? nil : "#{Time.now.to_i}-"

    "#{prefix}#{original_filename}"
  end
end
