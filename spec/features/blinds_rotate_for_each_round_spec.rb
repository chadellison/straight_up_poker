require "rails_helper"

RSpec.feature "blinds rotate for each round" do
  scenario "different players have blinds each round" do
    user = User.create(name: "oscar", username: "oscar", password: "password")
    ai_player1 = AiPlayer.create(name: "Arnold")
    ai_player2 = AiPlayer.create(name: "Jackie")
    ai_player3 = AiPlayer.create(name: "Rosco")

    visit root_path

    click_on "Login"
    fill_in "Username", with: "oscar"
    fill_in "Password", with: "password"
    click_on "Login"

    click_on "Play"

    select "4", from: "Player count"
    select "100", from: "Little blind"
    select "200", from: "Big blind"
    click_on "Play Poker"

    expect(Game.last.find_players.first.name).to eq "oscar"
    expect(Game.last.find_players[1].name).to eq "Arnold"
    expect(User.last.current_bet).to eq 100
    expect(AiPlayer.find(ai_player1.id).current_bet).to eq 200

    click_on "Call"
    click_on "Deal Flop"
    click_on "Check"
    click_on "Deal Turn"
    click_on "Check"
    click_on "Deal River"
    click_on "Check"

    click_on "Show Winner"
    click_on "Continue"

    expect(Game.last.find_players.first.name).to eq "Rosco"
    expect(Game.last.find_players[1].name).to eq "oscar"
    expect(AiPlayer.find(ai_player3.id).current_bet).to eq 100
    expect(User.last.current_bet).to eq 200

    click_on "Check"
    click_on "Deal Flop"
    click_on "Check"
    click_on "Deal Turn"
    click_on "Check"
    click_on "Deal River"
    click_on "Check"

    click_on "Show Winner"
    click_on "Continue"
    expect(Game.last.find_players.first.name).to eq "Jackie"
    expect(Game.last.find_players[1].name).to eq "Rosco"
    expect(Game.last.find_players[2].name).to eq "oscar"
    expect(AiPlayer.find(ai_player2.id).current_bet).to eq 100
    expect(AiPlayer.find(ai_player3.id).current_bet).to eq 200
    expect(User.last.current_bet).to eq 0
  end
end
