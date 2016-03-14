require 'rails_helper'

RSpec.describe Game, type: :model do

  it {should have_many(:ai_players)}
  it {should have_many(:users)}
  it {should have_many(:cards)}

  it "adds players to a game" do
    player = AiPlayer.create(name: "Rosco")
    game = Game.create(player_count: 2)
    game.add_players
    expect(game.ai_players.last).to eq player
  end

  it "sets the blinds" do
    player = AiPlayer.create(name: "Trump")
    user = User.create(name: "frank", username: "frank", password: "password")
    game = Game.create(player_count: 2, little_blind: 50, big_blind: 100)

    game.ai_players << player
    game.users << user
    expect(player.cash).to eq 1000
    expect(user.cash).to eq 1000
    game.set_blinds
    user = User.find(user.id)
    player = AiPlayer.find(player.id)
    expect(user.cash).to eq 950
    expect(player.cash).to eq 900
  end

  it "it deals pocket cards" do
    game = Game.create(player_count: 2)
    user = game.users.create(name: "Markus", username: "markus", password: "password")
    ai = game.ai_players.create(name: "Trump")

    create_cards

    expect(user.cards.count).to eq 0
    expect(ai.cards.count).to eq 0
    game.load_deck
    game.deal_pocket_cards
    expect(game.cards.count).to eq 48
    expect(user.cards.count).to eq 2
    expect(ai.cards.count).to eq 2

    four_player_game = Game.create(player_count: 4)
    user = four_player_game.users.create(name: "Jim", username: "jim", password: "password")
    ai1 = four_player_game.ai_players.create(name: "a")
    ai2 = four_player_game.ai_players.create(name: "b")
    ai3 = four_player_game.ai_players.create(name: "c")

    four_player_game.load_deck

    four_player_game.deal_pocket_cards
    expect(user.cards.count).to eq 2
    expect(ai1.cards.count).to eq 2
    expect(ai2.cards.count).to eq 2
    expect(ai3.cards.count).to eq 2
    expect(four_player_game.cards.count).to eq 44
  end

  it "loads a new deck for every game" do
    game = Game.create(player_count: 2, little_blind: 50, big_blind: 100)
    create_cards
    game.load_deck
    expect(game.cards).to eq Card.all
  end

  private

  def create_cards
    values = (2..10).to_a + ["Ace", "King", "Queen", "Jack"]
    suits = ["Hearts", "Diamonds", "Clubs", "Spades"]
    values.each do |value|
      suits.each do |suit|
        Card.create(value: value, suit: suit)
      end
    end
  end
end
