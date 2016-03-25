require "rails_helper"

RSpec.feature "user can play many rounds with many players" do
  scenario "user sees blind rotation and actions for all players" do
    AiPlayer.create(name: "Mary")
    AiPlayer.create(name: "Frank")
    User.create(name: "jones", username: "jones", password: "password")

    visit root_path
    click_on "Login"
    fill_in "Username", with: "jones"
    fill_in "Password", with: "password"
    click_on "Login"

    click_on "Play"
    select "3", from: "Player count"
    select "100", from: "Little blind"
    select "200", from: "Big blind"
    click_on "Play Poker"

    expect(Game.last.find_players[0]).to eq User.last

    expect(User.last.cash).to eq 900
    expect(Game.last.find_players[1].cash).to eq 800
    expect(Game.last.find_players[1].name).to eq "Frank"
    expect(page).to have_content "Mary Calls"
    click_on "Call"
    expect(page).to have_content "Frank Checks"
    expect(page).not_to have_content "Mary Checks"
    expect(page).not_to have_content "Mary Calls!"

    click_on "Deal Flop"
    expect(page).to have_content "Mary Checks"
    expect(page).not_to have_content "Frank Checks"
    click_on "Check"

    expect(page).to have_content "Frank Checks"
    expect(page).not_to have_content "Mary Checks"

    click_on "Deal Turn"
    expect(page).to have_content "Mary Checks"
    expect(page).not_to have_content "Frank Checks"
    click_on "Check"

    expect(page).to have_content "Frank Checks"
    expect(page).not_to have_content "Mary Checks"

    click_on "Deal River"
    expect(page).to have_content "Mary Checks"
    expect(page).not_to have_content "Frank Checks"
    click_on "Check"

    expect(page).to have_content "Frank Checks"
    expect(page).not_to have_content "Mary Checks"

    click_on "Show Winner"

    click_on "Continue"
    #frank user mary
    expect(Game.last.find_players.first.name).to eq "Mary"

    expect(User.last.current_bet).to eq 200
    expect(Game.last.find_players[1]).to eq User.last
    expect(Game.last.find_players[2].name).to eq "Frank"

    expect(page).to have_content "Frank Calls"
    expect(Game.last.find_players[2].total_bet).to eq 200
    expect(page).to have_content "Mary Calls"
    expect(Game.last.find_players.first.current_bet).to eq 100
    expect(Game.last.find_players.first.total_bet).to eq 200

    expect(Game.last.find_players[1].current_bet).to eq 200
    expect(Game.last.find_players[1].total_bet).to eq 200

    click_on "Check"

    expect(page).not_to have_content "Frank Checks"
    expect(page).not_to have_content "Mary Checks"

    click_on "Deal Flop"
# binding.pry
    expect(page).to have_content "Frank Checks"
    expect(page).to have_content "Mary Checks"
    click_on "Check"

    expect(page).not_to have_content "Frank Checks"
    expect(page).not_to have_content "Mary Checks"

    click_on "Deal Turn"
    expect(page).to have_content "Frank Checks"
    expect(page).to have_content "Mary Checks"
    click_on "Check"

    expect(page).not_to have_content "Frank Checks"
    expect(page).not_to have_content "Mary Checks"


    click_on "Deal River"
    expect(page).to have_content "Frank Checks"
    expect(page).to have_content "Mary Checks"
    click_on "Check"


    click_on "Show Winner"

    click_on "Continue"
    #frank mary user
    expect(Game.last.find_players.first.name).to eq "Frank"

    expect(User.last.current_bet).to eq 0
    expect(Game.last.find_players[1].name).to eq "Mary"
    expect(Game.last.find_players[2]).to eq User.last

    click_on "Call"
    expect(page).to have_content "Frank Calls"
    expect(page).to have_content "Mary Checks"

    click_on "Deal Flop"
    expect(page).not_to have_content "Frank Checks"
    expect(page).not_to have_content "Mary Checks"
    click_on "Check"

    expect(page).to have_content "Frank Checks"
    expect(page).to have_content "Mary Checks"

    click_on "Deal Turn"
    expect(page).not_to have_content "Frank Checks"
    expect(page).not_to have_content "Mary Checks"

    click_on "Check"

    expect(page).to have_content "Frank Checks"
    expect(page).to have_content "Mary Checks"

    click_on "Deal River"
    expect(page).not_to have_content "Frank Checks"
    expect(page).not_to have_content "Mary Checks"
    click_on "Check"

    expect(page).to have_content "Frank Checks"
    expect(page).to have_content "Mary Checks"

    click_on "Show Winner"

    click_on "Continue"
  end
end
