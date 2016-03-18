class User < ActiveRecord::Base
  has_secure_password

  validates :username, presence: true, uniqueness: true
  # validates :password, presence: true not sure why this is the case
  # has_many :cards
  # has_many :user_games
  # has_many :games, through: :user_games

  def present_cards
    "#{cards.first.value} of #{cards.first.suit}, #{cards.last.value} of #{cards.last.suit}"
  end

  def bet(amount)
    update(current_bet: amount)
    update(total_bet: total_bet + amount.to_i)
    new_amount = cash - amount.to_i
    update(cash: new_amount)
    # total_ai_bets = @game.ai_players.pluck(:total_bet).sum #look into more efficient way of doing this
    # @game.pot = total_ai_bets + total_bet
  end

  def fold
    if games.last.ai_players.count == 1
      games.last.update(winner: games.last.ai_players.last.name + " wins!")
    end
  end
end
