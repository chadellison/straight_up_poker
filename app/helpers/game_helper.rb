module GameHelper
  def call_or_check(user)
    if user.total_bet < @game.ai_players.maximum(:total_bet)
      "Call"
    else
      "Check"
    end
  end

  def display_opponents(game)
    game.find_players.reject do |player|
      player.class == User
    end
  end

  def present_flop(game)
    game.flop_cards.join(", ")
  end

  def display_button(game)
    unless game.users.last.folded
      return nil unless game.find_players.all? do |player|
        player.action || player.folded
      end
    end
    if game.users.last.total_bet != game.highest_bet && !game.users.last.folded
      nil
    elsif game.pocket_cards && game.flop_cards.empty?
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
    if find_winner(game).size == 1
      find_winner(game).last.name + " wins!"
    else
      find_winner(game).map do |winner|
        winner.name
      end.join(" and ") + " split the pot"
    end
  end

  def winning_hand(game)
    find_winner(game).map do |winner|
      "#{winner.name}: #{winner.present_cards}"
    end.join(", ")
  end

  def find_winner(game)
    game.winner.split(",").map do |player|
      if player.split.last == "user"
        User.find(player.split.first)
      else
        AiPlayer.find(player.split.first)
      end
    end
  end
end
