class Game < ActiveRecord::Base
  has_many :ai_players
  has_many :users

  def set_up_game(current_user)
    current_user.update(round: 0)
    add_players(current_user)
    set_blinds
    load_deck
    deal_pocket_cards(find_players)
  end

  def user_index
    users.last.round % find_players.length
  end

  def add_players(user)
    users << user.refresh
    players = AiPlayer.first(player_count - 1)
    players.each { |player| ai_players << player.refresh }
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

  def find_players
    (users + ai_players.order(:name)).rotate(users.last.round * -1)
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

  def user_action(action, amount = nil)
    user = users.last

    case action
    when "call"
      bet_amount = highest_bet - user.total_bet
      user.bet(bet_amount)
    when "bet"
      update(raise_count: raise_count + 1)
      user.bet(amount[:current_bet])
    when "fold"
      user.fold
    end
  end

  def rule_out(players)
    players.reject { |player| player.updated? || player.class == User }
  end

  def respond_to_user
    players = post_user_action_range.reject(&:updated?) 
    actions = take_action(players)
    unless find_players.all? { |player| player.updated? || player.folded }
      if index_raise > user_index
        players = rule_out(find_players[(index_raise + 1)..-1] + find_players[0...user_index])
        actions += take_action(players)
      else
        actions << take_action((find_players[(index_raise + 1)...user_index]).reject { |p| p.updated? })
        players = []
        players = find_players[0...(index_raise)].reject { |p| p.class == User || p.updated? } if find_players.last.class == User && !flop_cards.empty?
        actions += take_action(players)
      end
    end
    actions.join("\n")
  end

  def ai_action(user_action = nil, amount = nil)
    if user_action
      respond_to_user
    elsif !pocket_cards
      take_action(find_range).join("\n") unless find_range.empty?
    elsif users.last.folded
      actions = find_players.reject { |player| player.class == User }.map(&:take_action)
      until find_players.all? { |player| player.total_bet == highest_bet || player.folded } do
        find_players.reject { |player| player.class == User || player.updated? }.each do |player|
          actions << player.take_action
        end
      end
      actions.join("\n")
    else
      find_players[0...user_index].map(&:take_action).join("\n") unless user_index == 0
    end
  end

  def index_raise
    raiser = find_players.max_by { |player| player.total_bet }
    find_players.index(raiser)
  end

  def take_action(players)
    players.map { |player| player.take_action unless player.folded }.compact
  end

  def find_range
    case user_index
    when 1
      find_players[2..-1] << find_players.first
    when 0
      big_blind_ai = []
      big_blind_ai << find_players[1] if users.last.folded

      find_players[2..-1] + big_blind_ai
    when 2
      []
    else
      find_players[2...user_index]
    end
  end

  def post_user_action_range
    if user_index == 0 || user_index == 1
      find_players.reject { |player| player.class == User }
    elsif flop_cards.empty?
      find_players[(user_index + 1)..-1] +
      find_players[0...user_index]
    else
      find_players[(user_index + 1).. -1]
    end
  end

  def highest_bet
    find_players.max_by(&:total_bet).total_bet
  end

  def game_action
    if flop_cards.empty?
      deal_flop
    elsif turn_card.nil?
      deal_turn
    elsif river_card.nil?
      deal_river
    else
      update(winner: determine_winner) unless winner
    end
    ai_players.each { |player| player.update(action: false) }
    update(raise_count: 0)
    update_game if users.last.folded
  end

  def game_cards
    flop_cards + [turn_card, river_card]
  end

  def determine_winner
    players = {}
    all_players = find_players.reject { |player| player.folded == true }
    all_players.each do |player|
      players[player] = player.cards + game_cards
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
    else
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
    set_blinds
    deal_pocket_cards(find_players)
  end
end
