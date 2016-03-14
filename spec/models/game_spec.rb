require 'rails_helper'

RSpec.describe Game, type: :model do
  it "has many ai players" do
    game = Game.create(player_count: 2)

    assert game.ai_players
  end
  it "adds players to a game" do
    player = AiPlayer.create(name: "Rosco")
    game = Game.create(player_count: 2)
    game.add_players
    expect(game.ai_players.last).to eq player
  end

  it "sets the blinds" do
    player = AiPlayer.create(name: "Trump")
    user = User.create(name: "frank", username: "frank", password: "password")
    game = Game.create(player_count: 2)

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
end
