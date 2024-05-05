class User < ApplicationRecord
  has_many :stamp_middles
  has_one_attached :avatar, dependent: :destroy
  has_many :recipes
  has_many :comments, dependent: :destroy
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true

  # アバターのURLを返すメソッド

  def avatar_url(size: 100)
    if avatar.attached?
      # トリミングされた画像のバリアントを生成
      variant = avatar.variant(resize_to_fill: [size, size])
      # トリミングされた画像のURLを生成
      Rails.application.routes.url_helpers.rails_blob_path(variant.processed, only_path: true)
    else
      # アバターが添付されていない場合はnilを返す
      nil
    end
  end
end
