class AiPlayer < ActiveRecord::Base
  belongs_to :game

  include CardHelper

  def bet(amount)
    amount = cash if amount.to_i > cash
    update(current_bet: amount.to_i)
    update(total_bet: total_bet + amount)
    new_amount = cash - amount.to_i
    update(cash: new_amount)
    game.update(pot: game.pot + amount.to_i)
  end

  def all_in
    parting_cash = cash
    bet(cash)
    "#{name} Goes All In ($#{parting_cash})!"
  end

  def call(amount)
    return all_in if amount >= cash
    bet(amount)
    "#{name} Calls!"
  end

  def check
    "#{name} Checks"
  end

  def raise(amount)
    return all_in if amount >= cash
    if game.raise_count == 3
      normal_bet
    else
      call = game.highest_bet - total_bet
      bet(call + amount)
      game.update(raise_count: game.raise_count + 1)
      "#{name} Raises $#{amount}.00"
    end
  end

  def fold
    update(folded: true)
    still_playing = game.find_players.reject { |player| player.folded || player.out }
    if still_playing.count == 1
      winner = still_playing.last
      winner.take_winnings
      game.update(winner: "#{winner.id} #{winner.class}".downcase)
    end
    name + " Folds"
  end

  def make_snarky_remark
    "That's what I thought" #customize
  end

  def present_cards
    # cards.join(", ")
    cards.map do |card|
      "#{card.first} of #{card[1]}"
    end.join(", ")
  end

  def refresh
    update(cards: [],
            current_bet: 0,
            total_bet: 0,
            folded: false
          )
    update(out: true) if cash == 0
    self
  end

  def hand
    analyze = CardAnalyzer.new
    if game.flop_cards.empty?
      evaluate_pocket
    elsif game.turn_card.empty?
      hand = make_card_objects(cards + game.flop_cards)
      9 - analyze.index_hand(hand)
    elsif game.river_card.empty?
      hand = make_card_objects(cards + game.flop_cards + [game.turn_card])
      9 - analyze.index_hand(hand)
    else
      hand = make_card_objects(cards + game.flop_cards + [game.turn_card, game.river_card])
      9 - analyze.index_hand(hand)
    end
  end

  def evaluate_pocket
    current_hand = make_card_objects(cards)
    if current_hand.all? { |card| card.value == 2 || card.value == 7 }
      3
    elsif CardAnalyzer.new.index_hand(current_hand) == 8
      6
    elsif card_converter(current_hand).map(&:value).any? { |value| value > 10 }
      5
    else
      4
    end
  end

  def take_action(user_action = nil, amount = nil)
    update(action: true)
    risk_factor = rand(1..10)
    if bet_style == "always fold"
      always_fold
    elsif bet_style == "always raise"
      always_raise
    elsif bet_style == "conservative"
      bet_conservative(risk_factor)
    elsif bet_style == "aggressive"
      bet_aggressive(risk_factor)
    else
      normal_bet(user_action, amount)
    end
  end

  def bet_conservative(risk_factor)
    return all_in if risk_factor == 10 && hand > 6 && !game.flop_cards.empty?
    if game.highest_bet > total_bet && hand < 1
      risk_factor > 2 ? fold : normal_bet
    elsif game.highest_bet > total_bet && hand > 4
      risk_factor > 6 ? raise((game.highest_bet - total_bet) * 2) : normal_bet
    elsif game.highest_bet == total_bet && hand > 3
      risk_factor > 5 ? raise((risk_factor * 50) + game.little_blind) : normal_bet
    else
      normal_bet
    end
  end

  def bet_aggressive(risk_factor)
    return all_in if risk_factor > 7 && hand > 5 && !game.flop_cards.empty?
    if game.highest_bet > total_bet && hand < 1
      risk_factor > 5 ? fold : normal_bet
    elsif game.highest_bet > total_bet && hand > 2
      risk_factor > 5 ? raise((game.highest_bet - total_bet) + game.little_blind) : normal_bet
    elsif game.highest_bet == total_bet && hand > 1
      risk_factor > 4 ? raise(game.little_blind) : normal_bet
    else
      normal_bet
    end
  end

  def always_fold
    if current_bet == 0 || total_bet < game.highest_bet
      fold
    else
      normal_bet
    end
  end

  def always_raise
    raise(game.big_blind)
  end

  def normal_bet(user_action = nil, amount = nil)
    if game.highest_bet > total_bet
      call(game.highest_bet - total_bet)
    else
      check
    end
  end

  def updated?
    action && total_bet == game.highest_bet || folded || cash == 0
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
