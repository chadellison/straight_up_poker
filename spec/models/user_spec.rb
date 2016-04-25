require 'rails_helper'

RSpec.describe User, type: :model do
  it { validate_presence_of(:username) }
  it { validate_uniqueness_of(:username) }
  # it { validate_presence_of(:password) }
  it "belongs to a game" do
    user = User.create(username: "jones", name: "Jones", password: "password")
    game = Game.create
    game.users << user
    assert user.game
  end

  it "presents the cards" do
    user = User.create(name: "frank", username: "frank", password: "password")
    card1 = Card.new("7", "Hearts").present_card
    card2 = Card.new("9", "Spades").present_card
    user.update(cards: [card1, card2])
    expect(user.present_cards).to eq "7 of Hearts, 9 of Spades"
  end

  it "can place a bet" do
    game = Game.create
    user = game.users.create(name: "Jones", username: "jones", password: "password")
    expect(user.total_bet).to eq 0
    expect(user.cash).to eq 2000
    user.bet(50)
    expect(user.total_bet).to eq 50
    expect(user.cash).to eq 1950
  end

  it "can fold" do
    game = Game.create
    ai_player = game.ai_players.create(name: "Rosco")
    user = game.users.create(name: "Jones", username: "jones", password: "password")
    user.fold
    expect(AiPlayer.find(Game.last.winner.split.first).name + " wins!").to eq "Rosco wins!"
  end

  it "resets players cards and bets" do
    game = Game.create(little_blind: 30, big_blind: 60)
    game.users.create(username: "jones",
                            name: "jones",
                            password: "password",
                            cards: ["King of Hearts", "2 of Spades"],
                            cash: 1100,
                            current_bet: 200,
                            total_bet: 400,
                            )
    expect(User.last.cards.count).to eq 2
    expect(User.last.current_bet).to eq 200
    expect(User.last.total_bet).to eq 400

    User.last.refresh
    expect(User.last.name).to eq "jones"
    expect(User.last.cards.count).to eq 0
    expect(User.last.current_bet).to eq 0
    expect(User.last.total_bet).to eq 0
    expect(User.last.cash).to eq 1100
  end
end
