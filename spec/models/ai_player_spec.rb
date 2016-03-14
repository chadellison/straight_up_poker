require 'rails_helper'

RSpec.describe AiPlayer, type: :model do
  it {should have_many(:cards)}

  it "can bet" do
    ai = AiPlayer.create
    expect(ai.last_bet).to eq 0
    expect(ai.cash).to eq 1000
    ai.bet(200)
    expect(ai.last_bet).to eq 200
    expect(ai.cash).to eq 800
  end

  it "can check" do
    ai = AiPlayer.create(name: "Rosco")
    expect(ai.check).to eq "Rosco Checks!"
  end
end
