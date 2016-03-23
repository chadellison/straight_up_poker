class Game < ActiveRecord::Base
  has_many :ai_players
  has_many :user_games
  has_many :users, through: :user_games

  def set_up_game
    add_players
    order_players
    set_blinds
    load_deck
    deal_pocket_cards(find_players)
  end

  def initial_actions
    player = 2
    actions = []

    until player == users.last.round || player == find_players.size do
      find_players[player].update(action: true)
      actions << find_players[player].take_action
      player += 1
    end if find_players.count > 2
    actions.join("\n")
  end

  def add_players
    players = AiPlayer.first(Game.last.player_count - 1)
    players.each { |player| Game.last.ai_players << player.refresh }
  end

  def set_blinds
    find_players[0].bet(little_blind)
    find_players[1].bet(big_blind)
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

  def order_players
    ordered_players = (ai_players.map(&:id).insert(users.last.round, users.last.id))
    update(all_players: ordered_players)
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

  def deal_pocket_cards(players)
    players.each do |player|
      pocket_cards = []
      2.times { pocket_cards << cards.shuffle!.pop }
      player.update(cards: pocket_cards)
      update(cards: cards)
    end
  end

  def find_players
    all_players[users.last.round] = all_players[users.last.round].to_i

    all_players.map do |id|
      if id.class == Fixnum
        User.find(id)
      else
        AiPlayer.find(id)
      end
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
    end
  end

  def ai_action(user_action = nil, amount = nil)
    find_players.select do |player|
      player.action == false
    end.map do |player|
      player.update(action: true)
      player.take_action(user_action, amount)
    end.join("\n")
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
    ai_players.each { |player| player.update(action: false) }
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

    find_players.each { |player| player.refresh }
    load_deck
    users.last.update(round: users.last.round + 1)
    order_players
    set_blinds
    deal_pocket_cards(ai_players + users)
  end
end
