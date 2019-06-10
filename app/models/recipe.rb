class Recipe < ApplicationRecord
  has_attached_file :foto, styles: {thumb: "640x426" }
  validates_attachment_content_type :foto, content_type: /\Aimage\/.*\z/
  belongs_to :user
  has_many :ingredients 
  has_many :likes 

end
