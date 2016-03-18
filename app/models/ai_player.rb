class AiPlayer < ActiveRecord::Base
  # has_many :cards
  belongs_to :game

  def bet(amount)
    update(current_bet: amount)
    update(total_bet: total_bet + amount)
    new_amount = cash - amount
    update(cash: new_amount)
    total_ai_bets = game.ai_players.pluck(:total_bet).sum #look into more efficient way of doing this
    game.update(pot: total_ai_bets + game.users.last.total_bet)
  end

  def call
    bet_amount = game.users.last.total_bet - total_bet
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

  def take_winnings
    winnings = Game.last.pot
    update(cash: cash + winnings)
    name + " wins!"
  end
end
