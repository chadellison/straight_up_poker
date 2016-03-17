require 'rails_helper'

RSpec.describe User, type: :model do
  it { validate_presence_of(:username) }
  it { validate_uniqueness_of(:username) }
  # it { validate_presence_of(:password) }
  it { should have_many(:cards)}
  it "has many games" do
    user = User.create(username: "jones", name: "Jones", password: "password")
    assert user.user_games
    assert user.games
  end

  it "presents the cards" do
    user = User.create(name: "frank", username: "frank", password: "password")
    cards = user.cards.create(value: "7", suit: "Hearts")
    cards = user.cards.create(value: "9", suit: "Spades")
    expect(user.present_cards).to eq "7 of Hearts, 9 of Spades"
  end

  it "can place a bet" do
    game = Game.create
    user = game.users.create(name: "Jones", username: "jones", password: "password")
    expect(user.total_bet).to eq 0
    expect(user.cash).to eq 1000
    user.bet(50)
    expect(user.total_bet).to eq 50
    expect(user.cash).to eq 950
  end

  it "can fold" do
    game = Game.create
    ai_player = game.ai_players.create(name: "Rosco")
    user = game.users.create(name: "Jones", username: "jones", password: "password")
    user.fold
    expect(Game.last.winner).to eq "Rosco wins!"
  end
end
