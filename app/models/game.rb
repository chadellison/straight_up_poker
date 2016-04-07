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

  def user_index
    users.last.round % find_players.length
  end

  def initial_actions
    find_range.map do |player|
      # player.update(action: true)
      player.take_action unless player.folded
    end.join("\n") unless find_range.empty?
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

  def ai_action(user_action = nil, amount = nil)
    # actions = []
    #   ai_players.each do |player|
    #     player.update(action: false) if highest_bet > player.total_bet
    #   end
    #
    #   find_players.rotate(2).select do |player|
    #     player.action == false && !player.folded
    #   end.each do |player|
    #     player.update(action: true)
    #     actions << player.take_action(user_action, amount)
    #   end
    #
    # find_range.select do |player|
    #   player.total_bet != highest_bet unless player.folded
    # end.each do |player|
    #   actions << player.take_action(user_action, amount)
    # end
    # actions.join("\n")

    if user_action
      actions = []
      post_user_action_range.reject do |player|
        player.class == User || player.updated?
      end.each do |player|
        actions << player.take_action(user_action, amount)
      end
      unless find_players.all? { |player| player.updated? || player.folded || player.class == User }
        raiser = find_players.max_by { |player| player.total_bet }
        if find_players.index(raiser) > user_index
          actions << take_action((find_players[(find_players.index(raiser) + 1)..-1] + find_players[0...user_index]).reject { |p| p.updated? })
        # elsif flop_cards.empty? && user_index > find_players.index(raiser)
        #   players = (find_players[(find_players.index(raiser) + 1)...user_index] + find_players[0...2]).reject { |p| p.updated? || p.class == User }
        #   actions << take_action(players)
        else
          actions << take_action((find_players[(find_players.index(raiser) + 1)...user_index]).reject { |p| p.updated? })
        end
      end
      actions.join("\n")
    elsif !pocket_cards
      initial_actions
    elsif users.last.folded
      actions = []
      find_players.reject { |player| player.class == User }.each do |player|
        actions << player.take_action
      end
      until find_players.all? { |player| player.total_bet == highest_bet || player.folded } do
        find_players.reject { |player| player.class == User || player.total_bet == highest_bet }.each do |player|
          actions << player.take_action
        end
      end
      actions.join("\n")
    else
      find_players[0...user_index].map do |player|
        player.take_action
      end.join("\n") unless user_index == 0
    end
  end

  def take_action(players)
    players.map { |player| player.take_action }
  end

  def post_user_action_range
    if user_index == 0 || user_index == 1
      find_players
    elsif flop_cards.empty?
      find_players[(user_index + 1)..-1] +
      find_players[0...user_index]
    # elsif find_players.last.class == User && !flop_cards

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
