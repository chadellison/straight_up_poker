class Game < ActiveRecord::Base
  has_many :ai_players
  has_many :user_games
  has_many :users, through: :user_games

  def set_up_game
    add_players
    set_blinds
    #ais take action here...
    #all_players[2]..
    load_deck
    deal_pocket_cards(all_players)
  end

  def initial_actions
    player = 2
    actions = []
    until all_players[player].class == User do
      actions << all_players[player].take_action
      player += 1
    end if all_players.count > 2
    actions.join("\n")
  end

  def add_players
    players = AiPlayer.first(Game.last.player_count - 1)
    players.each { |player| Game.last.ai_players << player.refresh }
  end

  def set_blinds
    all_players.first.bet(little_blind)
    all_players[1].bet(big_blind)
    # users.last.bet(little_blind)
    # ai_players.first.bet(big_blind)
  end

  def load_deck
    values = (2..10).to_a + ["Ace", "King", "Queen", "Jack"]
    suits = ["Hearts", "Diamonds", "Clubs", "Spades"]
    values.each do |value|
      suits.each do |suit|
        cards << Card.new(value, suit).present_card
      end
    end
    update(cards: cards)
  end

  def all_players
    users + ai_players
  end

  def deal_flop
    flop_cards = []
    burn_card
    3.times do
      flop_cards << cards.shuffle!.pop
    end
    update(flop_cards: flop_cards)
    update(cards: cards)
  end

  def deal_turn
    burn_card
    turn_card = cards.shuffle!.pop
    update(turn_card: turn_card)
    update(cards: cards)
  end

  def deal_river
    burn_card
    river_card = cards.shuffle!.pop
    update(river_card: river_card)
    update(cards: cards)
  end

  def burn_card
    cards.pop
  end

  def present_flop
    flop_cards.join(", ")
  end

  def present_river
    Card.find(river_card_id).present_card
  end

  def deal_pocket_cards(players)
    players.each do |player|
      pocket_cards = []
      2.times { pocket_cards << cards.shuffle!.pop }
      player.update(cards: pocket_cards)
      update(cards: cards)
    end
  end

  def user_action(action, amount = nil)
    user = users.last
    if action == "call"
      total_amount = ai_players.maximum(:total_bet)
      bet_amount = total_amount - user.total_bet
      user.bet(bet_amount)
    elsif action == "bet"
      user.bet(amount[:current_bet])
    elsif action == "fold"
      user.fold
      #update game here
    end
  end

  def ai_action(user_action = nil, amount = nil)
    first_two = []
    first_two = all_players.first(2) if all_players.index(users.last) > 1

    if user_action
      (all_players[(all_players.index(users.last) + 1)..-1] + first_two).map do |player|
        player.take_action(user_action, amount)
      end.join("\n")
    else
      all_players[0...all_players.index(users.last)].map do |player|
        player.take_action
      end.join("\n")
    end
    # ai_players.map do |player|
    #   player.take_action(user_action, amount)
    # end.join("\n")
    # if user_action == "fold"
    #   ai_players.last.make_snarky_remark
    # elsif user_action == "bet"
    #   ai_players.last.call
    #   #for multiple ai_players consider a loop that has an ai take an action based on attributes
    # elsif user_action == "call" || "check"
    #   ai_players.last.check
    # elsif user_action.nil?
    #   ai_players.last.call if ai_players.maximum(:total_bet) > ai_players.last.total_bet
    #   ai_players.last.check if ai_players.maximum(:total_bet) == ai_players.last.total_bet
    # end
  end

  def display_button
    if pocket_cards && flop_cards.empty?
      "Deal Flop"
    elsif flop && turn_card.nil?
      "Deal Turn"
    elsif turn && !river_card
      "Deal River"
    elsif river && !winner
      "Show Winner"
    end
  end

  def game_action
    if flop_cards.empty?
      deal_flop
    elsif !turn_card
      deal_turn
    elsif !river_card
      deal_river
    else
      update(winner: determine_winner)
    end
  end

  def call_or_check
    if User.last.total_bet != AiPlayer.maximum(:total_bet)
      "Call"
    else
      "Check"
    end
  end

  def game_cards
    flop_cards + [turn_card, river_card]
  end

  def determine_winner
    players = {}
    (ai_players + users).each do |player|
      players[[player.id, player.class]] = player.cards + game_cards
    end

    CardAnalyzer.new.determine_winner(players)
  end

  def update_game
    if !pocket_cards
      update(pocket_cards: true)
    elsif pocket_cards && !flop
      update(flop: true)
    elsif flop && !turn
      update(turn: true)
    else #make conditional for fold
      update(river: true)
    end
  end

  def refresh
    update(
                           winner: nil,
                           bets: nil,
                           hands: nil,
                           pocket_cards: false,
                           flop: false,
                           turn: false,
                           river: false,
                           pot: 0,
                           cards: [],
                           flop_cards: [],
                           turn_card: nil,
                           river_card: nil
                           )

    (ai_players + users).each { |player| player.refresh }
    load_deck
    set_blinds
    deal_pocket_cards(ai_players + users)
  end
end
