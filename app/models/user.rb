class User < ApplicationRecord
  has_many :stamp_middles
  has_one_attached :avatar, dependent: :destroy

  has_many :comments, dependent: :destroy
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
