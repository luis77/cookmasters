class Recipe < ApplicationRecord
  has_attached_file :foto, styles: {recortada: "640x426#", thumb: "640x426" }
  validates_attachment_content_type :foto, content_type: /\Aimage\/.*\z/
  belongs_to :user
  has_many :ingredients, dependent: :destroy
  has_many :likes, dependent: :destroy



  def self.Recetas_con_mas_likes
      query = select("recipes.id, recipes.name, COUNT(l.recipe_id) as cantidad_likes, recipes.foto_file_name, recipes.created_at")
              .joins('INNER JOIN likes l ON recipes.id = l.recipe_id ')
			  .group(:name, :id,:created_at,:foto_file_name)
			  .order("cantidad_likes Desc")
   end


end

