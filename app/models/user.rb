class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :recipes 

  #validates :email, presence: true, uniqueness: true
  #validates :username, presence: true, uniqueness: true
  #validates :name, presence: true, length: {in: 3..12}
  #validates :last_name, presence: true, length: {in: 3..12}

end
