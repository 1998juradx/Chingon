class ImageUploader < CarrierWave::Uploader::Base

  # https://github.com/carrierwaveuploader/carrierwave/wiki/How-to%3a-Define-different-storage-configuration-for-each-Uploader.

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  self.fog_public = false

  # Choose what kind of storage to use for this uploader:
  # storage :file
  storage :fog

  process resize_to_fill: [1280, 0]

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # version :high do
  #   process resize_to_fill: [1280, 0]
  # end

  version :thumbnail do
    process resize_to_fill: [320, 320]
  end

end
