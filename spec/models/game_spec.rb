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
end
