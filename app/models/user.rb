class User < ActiveRecord::Base
  has_secure_password

  validates :username, presence: true, uniqueness: true
  # validates :password, presence: true not sure why this is the case
  has_many :user_games
  has_many :games, through: :user_games

  def present_cards
    cards.join(", ")
  end

  def bet(amount)
    return check_bet(amount) if check_bet(amount)
    update(current_bet: amount)
    update(total_bet: total_bet + amount.to_i)
    new_amount = cash - amount.to_i
    update(cash: new_amount)
    Game.last.update(pot: Game.last.pot + amount.to_i)
  end

  def check_bet(amount)
    "Error" if amount.to_i > cash || amount.to_i < Game.last.little_blind
  end

  def fold
    update(folded: true)
    if games.last.ai_players.count == 1
      games.last.update(winner: "#{games.last.ai_players.last.id} ai_player")
    end
  end

  def take_winnings
    winnings = Game.last.pot
    update(cash: cash + winnings)
    "#{id} user"
  end

  def refresh
    update(cards: [],
            current_bet: 0,
            total_bet: 0,
            folded: false,
          )
    self
  end
end
