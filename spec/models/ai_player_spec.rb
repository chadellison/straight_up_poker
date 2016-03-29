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
    #make code for ai folding here
    #include ai bet style (perhaps: always fold)
  end
end
