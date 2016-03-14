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
    user = User.create(name: "Jones", username: "jones", password: "password")
    cards = user.cards.create(value: "7", suit: "Hearts")
    cards = user.cards.create(value: "9", suit: "Spades")
    expect(user.present_cards).to eq "7 of Hearts, 9 of Spades"
  end
end
