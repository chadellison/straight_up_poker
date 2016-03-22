module GameHelper
  def call_or_check(user, max_bet = @game.ai_players.maximum(:total_bet))
    if user.total_bet < max_bet
      "Call"
    else
      "Check"
    end
  end
end
