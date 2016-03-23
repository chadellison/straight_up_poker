class AiPlayer < ActiveRecord::Base
  belongs_to :game

  def bet(amount)
    update(current_bet: amount.to_i)
    update(total_bet: total_bet + amount)
    new_amount = cash - amount.to_i
    update(cash: new_amount)
    game.update(pot: game.pot + amount.to_i)
  end

  def call(amount)
    bet(amount)
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
    highest_bet = 0
    if game.ai_players.maximum(:total_bet) > game.users.maximum(:total_bet)
      highest_bet = game.ai_players.maximum(:total_bet)
    else
      highest_bet = game.users.maximum(:total_bet)
    end
    #
    if highest_bet > total_bet
      call(highest_bet - total_bet)
    elsif user_action == "fold"
      make_snarky_remark
    else
      check
    end

    # if user_action.nil? && highest_bet > total_bet
    #   call(highest_bet - total_bet)
    # elsif user_action == "fold"
    #   make_snarky_remark
    # elsif user_action == "bet" || "call"
    #   if total_bet == game.users.maximum(:total_bet)
    #     check
    #   else
    #     call(game.users.maximum(:total_bet) - total_bet)
    #   end
    # else
    #   check
    # end
  end

  def take_winnings
    winnings = Game.last.pot
    update(cash: cash + winnings)
    "#{id} ai_player"
  end
end
