class AddPhotoUrlToRecipes < ActiveRecord::Migration[5.1]
  def change
    add_column :recipes, :photo_url, :string
  end
end
