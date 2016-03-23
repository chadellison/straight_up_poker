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

  def take_action(user_action = nil, amount = nil)
    if user_action.nil? && Game.last.ai_players.maximum(:total_bet) > total_bet
      call_ai
      # else
      #   check
      # end

    elsif user_action == "fold"
      make_snarky_remark
    elsif user_action == "bet" || "call"
      if total_bet == User.last.total_bet
        check
      else
        call
      end
    else
      check
    end
  end

  def call_ai
    bet_amount = game.ai_players.maximum(:total_bet) - total_bet
    bet(bet_amount)
    "#{name} Calls!"
  end

  def take_winnings
    winnings = Game.last.pot
    update(cash: cash + winnings)
    "#{id} ai_player"
  end
end
