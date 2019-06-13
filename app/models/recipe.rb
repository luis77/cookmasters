class Recipe < ApplicationRecord
  has_attached_file :foto, styles: {recortada: "640x426#", thumb: "640x426" }
  validates_attachment_content_type :foto, content_type: /\Aimage\/.*\z/
  #belongs_to :user
  has_many :ingredients, dependent: :destroy
  has_many :likes, dependent: :destroy

end
