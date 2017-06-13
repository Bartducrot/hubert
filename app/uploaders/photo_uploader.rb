class PhotoUploader < CarrierWave::Uploader::Base
  include Cloudinary::CarrierWave

  process eager: true  # Force version generation at upload time.

  process convert: 'jpg'

  version :square do
    cloudinary_transformation width: 150, height: 150, crop: :thumb, gravity: :face
  end
end
