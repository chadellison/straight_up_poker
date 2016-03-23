module GameHelper
  def call_or_check(user)
    if user.total_bet < @game.ai_players.maximum(:total_bet)
      "Call"
    else
      "Check"
    end
  end

  def present_flop(game)
    game.flop_cards.join(", ")
  end

  def display_button(game)
    if game.pocket_cards && game.flop_cards.empty?
      "Deal Flop"
    elsif game.flop && game.turn_card.nil?
      "Deal Turn"
    elsif game.turn && !game.river_card
      "Deal River"
    elsif game.river && !game.winner
      "Show Winner"
    end
  end

  def declare_winner(game)
    find_winner(game).name + " wins!"
  end

  def winning_hand(game)
    find_winner(game).present_cards
  end

  def find_winner(game)
    if game.winner.split.last == "user"
      User.find(game.winner.split.first)
    else
      AiPlayer.find(game.winner.split.first)
    end
  end
end
