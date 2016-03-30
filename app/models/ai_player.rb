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

  def fold
    update(folded: true)
    folded_players = game.find_players.select { |player| player.folded == false }
    if folded_players.count == 1
      winner = folded_players.last
      game.update(winner: "#{winner.id} #{winner.class}".downcase)
    end
  end

  def make_snarky_remark
    "That's what I thought" #customize
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
    #take bet style into consideration here
    if highest_bet > total_bet
      call(highest_bet - total_bet)
    elsif user_action == "fold"
      make_snarky_remark
    else
      check
    end
  end

  def highest_bet
    if game.ai_players.maximum(:total_bet) > game.users.maximum(:total_bet)
      game.ai_players.maximum(:total_bet)
    else
      game.users.maximum(:total_bet)
    end
  end

  def take_winnings
    winnings = Game.last.pot
    update(cash: cash + winnings)
    "#{id} ai_player"
  end

  def split_pot(number_of_players)
    winnings = Game.last.pot / number_of_players.to_f.round(2)
    update(cash: cash + winnings)
    "#{id} ai_player"
  end
end
