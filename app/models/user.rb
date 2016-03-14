class User < ActiveRecord::Base
  has_secure_password

  validates :username, presence: true, uniqueness: true
  # validates :password, presence: true not sure why this is the case
  has_many :cards
  has_many :user_games
  has_many :games, through: :user_games

  def present_cards
    "#{cards.first.value} of #{cards.first.suit}, #{cards.last.value} of #{cards.last.suit}"
  end
end
