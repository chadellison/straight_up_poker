require 'rails_helper'

RSpec.describe AiPlayer, type: :model do
  it {should have_many(:cards)}
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
end
