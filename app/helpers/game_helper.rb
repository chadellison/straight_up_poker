module GameHelper
  include CardHelper

  def call_or_check(user)
    if user.total_bet < @game.ai_players.maximum(:total_bet)
      "Call"
    else
      "Check"
    end
  end

  def display_opponents(game)
    game.players_left.reject do |player|
      player.class == User
    end
  end

  def api_cards
    url = "http://deckofcardsapi.com/api/deck/new/draw/?count=52"
    response = Faraday.get(url)
    JSON.parse(response.body)["cards"]
  end

  def card_code(card)
    if card.split.first[0] == "1"
      "0" + card.split.last[0].upcase
    else
      card.split.first[0].upcase + card.split.last[0].upcase
    end
  end

  def present_flop(game)
    flop_codes = game.flop_cards.map { |card| card_code(card) }
    api_cards.select { |card| flop_codes.include?(card["code"]) }
    .map do |card|
      card["image"]
    end
  end

  def present_pocket(game)
    pocket_cards = game.users.last.cards.map { |card| card_code(card) }
    api_cards.select { |card| pocket_cards.include?(card["code"]) }
    .map do |card|
      card["image"]
    end
  end

  def card_image(game_card)
    api_cards.detect do |card|
      card["code"] == card_code(game_card)
    end["image"] if game_card
  end

  def display_button(game)
    if !game.users.last.folded && !players_updated?(game)
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

  def to_call(game)
    call_amount = game.highest_bet - game.users.last.total_bet
    "$#{call_amount}.00 to call" unless call_amount == 0
  end

  def players_updated?(game)
    game.find_players.all? do |player|
      player.updated? && player.action || player.folded || player.cash == 0
    end
  end

  def declare_winner(game)
    if find_winner(game).size == 1
      find_winner(game).last.name + " wins with a " + winning_hand(game) + "!"
    else
      find_winner(game).map do |winner|
        winner.name
      end.join(" and ") + " split the pot with " + winning_hand(game).pluralize(2) + "!"
    end
  end

  def declare_champion(game)
    "Congratulations #{find_winner(game).last.name}! You are the champion, and also a hoss beast!"
  end

  def winning_cards(game)
    find_winner(game).map do |winner|
      "#{winner.name}: #{winner.present_cards}"
    end.join(", ")
  end

  def winning_hand(game)
    game_cards = game.flop_cards.empty? ? [] : game.game_cards
    cards = find_winner(game).last.cards + game_cards

    case CardAnalyzer.new.index_hand(make_card_objects(cards))
    when 0
      "Royal Flush"
    when 1
      "Straight Flush"
    when 2
      "Four of a Kind"
    when 3
      "Full House"
    when 4
      "Flush"
    when 5
      "Straight"
    when 6
      "Three of a Kind"
    when 7
      "Two Pair"
    when 8
      "Two of a Kind"
    else
      "High Card"
    end
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
