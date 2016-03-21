class AiPlayer < ActiveRecord::Base
  belongs_to :game

  def bet(amount)
    update(current_bet: amount.to_i)
    update(total_bet: total_bet + amount)
    new_amount = cash - amount.to_i
    update(cash: new_amount)
    Game.last.update(pot: Game.last.pot + amount.to_i)
  end

  def call
    bet_amount = User.maximum(:total_bet) - total_bet
    bet(bet_amount)
    "#{name} Calls!"
  end

  def check
    "#{name} Checks!"
  end

  def make_snarky_remark
    "That's what I thought"
  end

  def present_cards
    cards.join(", ")
  end

  def refresh
    update(cards: [],
            current_bet: 0,
            total_bet: 0,
          )
    self
  end

  def take_winnings
    winnings = Game.last.pot
    update(cash: cash + winnings)
    name + " wins!"
  end
end
