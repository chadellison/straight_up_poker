class User < ActiveRecord::Base
  has_secure_password

  validates :username, presence: true, uniqueness: true
  # validates :password, presence: true not sure why this is the case
  belongs_to :game

  def present_cards
    cards.join(", ")
  end

  def bet(amount)
    return check_bet(amount) if check_bet(amount)
    update(current_bet: amount)
    update(total_bet: total_bet + amount.to_i)
    new_amount = cash - amount.to_i
    update(cash: new_amount)
    game.update(pot: game.pot + amount.to_i)
  end

  def check_bet(amount)
    "Error" if amount.to_i > cash || amount.to_i < game.little_blind
  end

  def fold
    update(folded: true)
    folded_players = game.find_players.select { |player| player.folded == false }
    if folded_players.count == 1
      winner = folded_players.last
      game.update(winner: "#{winner.id} #{winner.class}".downcase)
    end
  end

  def updated?
    total_bet == game.highest_bet
  end

  def take_winnings
    winnings = game.pot
    update(cash: cash + winnings)
    "#{id} user"
  end

  def split_pot(number_of_players)
    winnings = game.pot / number_of_players.to_f.round(2)
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
