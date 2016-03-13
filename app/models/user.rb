class User < ActiveRecord::Base
  has_secure_password

  validates :username, presence: true, uniqueness: true
  validates :password, presence: true
  has_many :user_games
  has_many :games, through: :user_games
end
