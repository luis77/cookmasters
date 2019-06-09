class Recipe < ApplicationRecord
  has_attached_file :foto, styles: { medium: "1200x720", thumb: "362x240>" }
  validates_attachment_content_type :foto, content_type: /\Aimage\/.*\z/
  belongs_to :user
  has_many :ingredients 
  has_many :likes 

end
