require 'rails_helper'

RSpec.describe Game do

  it "adds players to a game" do
    player = AiPlayer.create(name: "Rosco")
    game = Game.new(2)
    game.add_players
    expect(game.ai_players.last).to eq player
  end

  it "sets the blinds" do
    player = AiPlayer.create(name: "Trump")
    user = User.create(name: "frank", username: "frank", password: "password")
    game = Game.new(2, 50)

    game.add_players
    game.user << user
    expect(player.cash).to eq 1000
    expect(user.cash).to eq 1000
    game.set_blinds
    user = User.find(user.id)
    player = AiPlayer.find(player.id)
    expect(user.cash).to eq 950
    expect(player.cash).to eq 900
  end

  it "it deals pocket cards" do
    ai = AiPlayer.create(name: "Trump")
    user = User.create(name: "Marcus", username: "marcus", password: "password")
    game = Game.new(2)
    game.user << user
    game.add_players

    game.load_deck
    expect(user.cards.count).to eq 0
    expect(ai.cards.count).to eq 0
    game.deal_pocket_cards(game.user)
    game.deal_pocket_cards(game.ai_players)

    expect(game.cards.count).to eq 48
    expect(game.user.last.cards.count).to eq 2
    expect(game.ai_players.last.cards.count).to eq 2

    four_player_game = Game.new(4)
    user = User.create(name: "Jim", username: "jim", password: "password")
    ai1 = AiPlayer.create(name: "a")
    ai2 = AiPlayer.create(name: "b")
    ai3 = AiPlayer.create(name: "c")

    four_player_game.user << user
    four_player_game.add_players

    four_player_game.load_deck

    four_player_game.deal_pocket_cards(four_player_game.ai_players)
    four_player_game.deal_pocket_cards(four_player_game.user)
    expect(game.user.last.cards.count).to eq 2

    expect(game.ai_players.all? { |ai| ai.cards.size == 2 }).to eq true
    expect(four_player_game.cards.count).to eq 44
  end

  it "loads a new deck for every game" do
    game = Game.new
    game.load_deck
    expect(game.cards.count).to eq 52
  end

  it "ai's can perform an action based on a user action" do
    game = Game.new
    AiPlayer.create(name: "Rosco")
    game.add_players
    user_action = "check"
    expect(game.ai_action(user_action)).to eq "Rosco Checks!"
  end

  it "updates the state of the game" do
    game = Game.new
    expect(game.pocket_cards).to eq false
    game.update_game
    expect(game.pocket_cards).to eq true
    expect(game.flop).to eq false
    game.update_game
    expect(game.flop).to eq true
    expect(game.turn).to eq false
    game.update_game
    expect(game.turn).to eq true
    expect(game.river).to eq false
    game.update_game
    expect(game.river).to eq true
  end

  it "deals flop" do
    game = Game.new
    game.load_deck
    expect(game.cards.count).to eq 52
    game.deal_flop
    expect(game.cards.count).to eq 48
    expect(game.flop_cards.count).to eq 3
  end

  # it "takes a user action" do
  #   game = Game.create
  #   assert game.user_action("check")
  # end

  it "deals the turn" do
    game = Game.new
    game.load_deck
    expect(game.cards.count).to eq 52
    refute game.turn_card
    game.deal_turn
    expect(game.cards.count).to eq 50
    assert game.turn_card
  end

  it "deals the river" do
    game = Game.new
    game.load_deck
    expect(game.cards.count).to eq 52
    refute game.river_card
    game.deal_river
    expect(game.cards.count).to eq 50
    assert game.river_card
  end

  # it "can determine the winner" do
  #   game = Game.new
  #   ai_player = AiPlayers.create(name: "Rosco")
  #   user = Users.create(name: "jones", username: "jones", password: "password")
  #   game.user << user
  #   game.add_players
  #   ace = Card.new("Ace", "Hearts")
  #   king = Card.new("King", "Hearts")
  #   user.update(cards: [ace, king]
  #
  #   two = Card.new("2", "Hearts")
  #   three = Card.new("3", "clubs")
  #   ai_player.update(cards: [two, three])
  #
  #   card1 = Card.new("Ace", "Spades")
  #   card2 = Card.new("King", "Spades")
  #   card3 = Card.new("Ace", "Clubs")
  #
  #   game.update(flop_card_ids: [card1.id, card2.id, card3.id])
  #
  #   card4 = Card.create(value: "7", suit: "Hearts")
  #   game.update(turn_card_id: card4.id)
  #
  #   card5 = Card.create(value: "9", suit: "Clubs")
  #
  #   game.update(river_card_id: card5.id)
  #   expect(game.determine_winner).to eq "jones wins!"
  # end
end
