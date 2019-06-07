class AddFotoToRecipes < ActiveRecord::Migration[5.2]
  def change
     add_attachment :recipes, :foto
  end
end
