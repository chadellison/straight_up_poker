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
    expect(ai.check).to eq "Rosco Checks!"
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
    expect(ai_player.folded).to eq false

    ai_player.fold

    expect(ai_player.folded).to eq true
  end

  it "evaluates the quality of a current hand" do
    game = Game.create
    ai_player = game.ai_players.create(name: "Rosco")

    cards = ["2 of Hearts", "7 of Spades"]
    game.ai_players.last.update(cards: cards)
    expect(ai_player.hand).to eq 5

    cards = ["2 of Clubs", "10 of Hearts"]
    game.ai_players.last.update(cards: cards)
    expect(AiPlayer.last.hand).to eq 6

    cards = ["4 of Diamonds", "King of Hearts"]
    game.ai_players.last.update(cards: cards)
    expect(AiPlayer.last.hand).to eq 7

    cards = ["3 of Hearts", "3 of Spades"]
    game.ai_players.last.update(cards: cards)
    expect(AiPlayer.last.hand).to eq 8

    cards = ["Ace of Hearts", "Ace of Spades"]
    game.ai_players.last.update(cards: cards)
    expect(AiPlayer.last.hand).to eq 8
  end
end
