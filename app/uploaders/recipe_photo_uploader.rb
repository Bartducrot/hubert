# encoding: utf-8

class RecipePhotoUploader < CarrierWave::Uploader::Base

 include Cloudinary::CarrierWave
end
