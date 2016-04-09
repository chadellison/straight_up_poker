require 'rails_helper'

RSpec.describe AiPlayer, type: :model do
  it {should belong_to(:game)}

  it "can bet" do
    game = Game.create
    game.users.create(name: "jones", username: "jones", password: "password")
    ai = game.ai_players.create
    expect(ai.current_bet).to eq 0
    expect(ai.cash).to eq 1000
    ai.bet(200)
    expect(ai.current_bet).to eq 200
    expect(ai.cash).to eq 800
  end

  it "can check" do
    ai = AiPlayer.create(name: "Rosco")
    expect(ai.check).to eq "Rosco Checks"
  end

  it "cand make a snarky remark" do
    ai = AiPlayer.new
    expect(ai.make_snarky_remark).to eq "That's what I thought"
  end

  it "resets ai_players cards and bets" do
    AiPlayer.create(name: "Martha",
                  cards: ["King of Hearts", "2 of Spades"],
                  cash: 800,
                  current_bet: 200,
                  total_bet: 400,
                )
    expect(AiPlayer.last.cards.count).to eq 2
    expect(AiPlayer.last.current_bet).to eq 200
    expect(AiPlayer.last.total_bet).to eq 400

    AiPlayer.last.refresh
    expect(AiPlayer.last.name).to eq "Martha"
    expect(AiPlayer.last.cards.count).to eq 0
    expect(AiPlayer.last.current_bet).to eq 0
    expect(AiPlayer.last.total_bet).to eq 0
    expect(AiPlayer.last.cash).to eq 800
  end

  it "can fold" do
    game = Game.create
    user = game.users.create(name: "jones", username: "jones", password: "password")
    ai_player = game.ai_players.create(name: "Jannet")
    ai_player2 = game.ai_players.create(name: "Frank")
    expect(ai_player.folded).to eq false

    ai_player.fold

    expect(ai_player.folded).to eq true
    expect(ai_player2.folded).to eq false
  end

  it "evaluates the quality of a current hand" do
    game = Game.create
    ai_player = game.ai_players.create(name: "Rosco")

    cards = ["2 of Hearts", "7 of Spades"]
    game.ai_players.last.update(cards: cards)
    expect(ai_player.hand).to eq 3

    cards = ["2 of Clubs", "10 of Hearts"]
    game.ai_players.last.update(cards: cards)
    expect(AiPlayer.last.hand).to eq 4

    cards = ["4 of Diamonds", "King of Hearts"]
    game.ai_players.last.update(cards: cards)
    expect(AiPlayer.last.hand).to eq 5

    cards = ["3 of Hearts", "3 of Spades"]
    game.ai_players.last.update(cards: cards)
    expect(AiPlayer.last.hand).to eq 6

    cards = ["Ace of Hearts", "Ace of Spades"]
    game.ai_players.last.update(cards: cards)
    expect(AiPlayer.last.hand).to eq 6

    flop_cards = ["Ace of Clubs", "Ace of Diamonds", "King of Hearts"]
    Game.last.update(flop_cards: flop_cards)

    expect(AiPlayer.last.hand).to eq 7

    cards = ["5 of Hearts", "Jack of Clubs"]
    game.ai_players.last.update(cards: cards)
    expect(AiPlayer.last.hand).to eq 1

    cards = ["Ace of Hearts", "King of Diamonds"]
    game.ai_players.last.update(cards: cards)
    expect(AiPlayer.last.hand).to eq 6

    cards = ["Jack of Hearts", "King of Diamonds"]
    game.ai_players.last.update(cards: cards)
    expect(AiPlayer.last.hand).to eq 2

    cards = ["Ace of Hearts", "4 of Diamonds"]
    game.ai_players.last.update(cards: cards)
    expect(AiPlayer.last.hand).to eq 3

    turn_card = "Queen of Clubs"
    Game.last.update(turn_card: turn_card)

    cards = ["Jack of Hearts", "10 of Diamonds"]
    game.ai_players.last.update(cards: cards)
    expect(AiPlayer.last.hand).to eq 4

    flop_cards = ["Ace of Clubs", "Queen of Clubs", "King of Clubs"]
    Game.last.update(flop_cards: flop_cards)

    cards = ["3 of Clubs", "10 of Clubs"]
    game.ai_players.last.update(cards: cards)
    expect(AiPlayer.last.hand).to eq 5

    cards = ["Jack of Clubs", "10 of Clubs"]
    game.ai_players.last.update(cards: cards)
    expect(AiPlayer.last.hand).to eq 9
  end

  it "can raise" do
    game = Game.create
    oscar = game.ai_players.create(name: "Oscar")
    user = game.users.new(name: "Jones")
    user.bet(100)
    expect(oscar.raise(100)).to eq "Oscar Raises $100.00"
    expect(game.users.last.total_bet).to eq 100
    expect(game.ai_players.last.total_bet).to eq 200
  end
end
