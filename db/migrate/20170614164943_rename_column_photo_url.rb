class RenameColumnPhotoUrl < ActiveRecord::Migration[5.1]
  def change
    rename_column :recipes, :photo_url, :photo
  end
end
