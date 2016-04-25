require "rails_helper"

RSpec.feature "user can play multiple ais" do
  scenario "user sees blind rotation and actions of each ai" do
    AiPlayer.create(name: "A")
    AiPlayer.create(name: "B")
    AiPlayer.create(name: "C")
    AiPlayer.create(name: "D")
    User.create(name: "jones", username: "jones", password: "password")

    visit root_path
    click_on "Login"
    fill_in "Username", with: "jones"
    fill_in "Password", with: "password"
    click_button "Login"

    click_on "Play"
    select "5", from: "Player count"
    select "3000", from: "Buy in"
    select "50", from: "Little blind"
    select "100", from: "Big blind"
    click_on "Play Poker"

    expect(Game.last.find_players[0]).to eq User.last
    expect(User.last.cash).to eq 1950
    expect(Game.last.find_players[1].cash).to eq 2900
    expect(page).to have_content Game.last.find_players[2].name + " Calls!"
    expect(page).to have_content Game.last.find_players[3].name + " Calls!"
    expect(page).to have_content Game.last.find_players[4].name + " Calls!"

    click_on "Call"
    expect(page).to have_content Game.last.find_players[1].name + " Checks"
    click_on "Deal Flop"
    expect(page).not_to have_content Game.last.find_players[2].name + " Checks"
    expect(page).not_to have_content Game.last.find_players[3].name + " Checks"
    expect(page).not_to have_content Game.last.find_players[4].name + " Checks"

    click_on "Check"
    expect(page).to have_content Game.last.find_players[1].name + " Checks"
    expect(page).to have_content Game.last.find_players[2].name + " Checks"
    expect(page).to have_content Game.last.find_players[3].name + " Checks"
    expect(page).to have_content Game.last.find_players[4].name + " Checks"

    click_on "Deal Turn"
    expect(page).not_to have_content Game.last.find_players[1].name + " Checks"
    expect(page).not_to have_content Game.last.find_players[2].name + " Checks"
    expect(page).not_to have_content Game.last.find_players[3].name + " Checks"
    expect(page).not_to have_content Game.last.find_players[4].name + " Checks"

    click_on "Bet / Raise"
    fill_in "Current bet", with: "200"
    click_on "Submit"

    expect(page).to have_content Game.last.find_players[1].name + " Calls!"
    expect(page).to have_content Game.last.find_players[2].name + " Calls!"
    expect(page).to have_content Game.last.find_players[3].name + " Calls!"
    expect(page).to have_content Game.last.find_players[4].name + " Calls!"

    click_on "Deal River"
    expect(page).not_to have_content Game.last.find_players[1].name + " Checks"
    expect(page).not_to have_content Game.last.find_players[2].name + " Checks"
    expect(page).not_to have_content Game.last.find_players[3].name + " Checks"
    expect(page).not_to have_content Game.last.find_players[4].name + " Checks"

    click_on "Check"
    expect(page).to have_content Game.last.find_players[1].name + " Checks"
    expect(page).to have_content Game.last.find_players[2].name + " Checks"
    expect(page).to have_content Game.last.find_players[3].name + " Checks"
    expect(page).to have_content Game.last.find_players[4].name + " Checks"

    refute Game.last.winner

    click_on "Show Winner"

    assert Game.last.winner

    expect(Game.last.find_players.first).to eq User.last

    click_on "Continue"
    expect(Game.last.find_players[1]).to eq User.last
    expect(page).to have_content Game.last.find_players[2].name + " Calls"
    expect(page).to have_content Game.last.find_players[3].name + " Calls"
    expect(page).to have_content Game.last.find_players[4].name + " Calls"
    expect(page).to have_content Game.last.find_players[0].name + " Calls"

    click_on "Check"
    expect(page).not_to have_content Game.last.find_players[0].name + " Calls"
    expect(page).not_to have_content Game.last.find_players[2].name + " Calls"
    expect(page).not_to have_content Game.last.find_players[3].name + " Calls"
    expect(page).not_to have_content Game.last.find_players[4].name + " Calls"

    click_on "Deal Flop"
    expect(page).to have_content Game.last.find_players[0].name + " Checks"

    expect(page).not_to have_content Game.last.find_players[2].name + " Checks"
    expect(page).not_to have_content Game.last.find_players[3].name + " Checks"
    expect(page).not_to have_content Game.last.find_players[4].name + " Checks"

    click_on "Check"
    expect(page).to have_content Game.last.find_players[2].name + " Checks"
    expect(page).to have_content Game.last.find_players[3].name + " Checks"
    expect(page).to have_content Game.last.find_players[4].name + " Checks"
    expect(page).not_to have_content Game.last.find_players[0].name + " Checks"

    click_on "Deal Turn"
    expect(page).to have_content Game.last.find_players[0].name + " Checks"

    expect(page).not_to have_content Game.last.find_players[2].name + " Checks"
    expect(page).not_to have_content Game.last.find_players[3].name + " Checks"
    expect(page).not_to have_content Game.last.find_players[4].name + " Checks"

    click_on "Check"
    expect(page).to have_content Game.last.find_players[2].name + " Checks"
    expect(page).to have_content Game.last.find_players[3].name + " Checks"
    expect(page).to have_content Game.last.find_players[4].name + " Checks"
    expect(page).not_to have_content Game.last.find_players[0].name + " Checks"

    click_on "Deal River"
    expect(page).to have_content Game.last.find_players[0].name + " Checks"

    expect(page).not_to have_content Game.last.find_players[2].name + " Checks"
    expect(page).not_to have_content Game.last.find_players[3].name + " Checks"
    expect(page).not_to have_content Game.last.find_players[4].name + " Checks"

    click_on "Check"
    expect(page).to have_content Game.last.find_players[2].name + " Checks"
    expect(page).to have_content Game.last.find_players[3].name + " Checks"
    expect(page).to have_content Game.last.find_players[4].name + " Checks"
    expect(page).not_to have_content Game.last.find_players[0].name + " Checks"

    click_on "Show Winner"

    click_on "Continue"
    expect(Game.last.find_players[2]).to eq User.last
    expect(page).not_to have_content Game.last.find_players[0].name + " Checks"
    expect(page).not_to have_content Game.last.find_players[1].name + " Checks"
    expect(page).not_to have_content Game.last.find_players[3].name + " Checks"
    expect(page).not_to have_content Game.last.find_players[4].name + " Checks"

    click_on "Call"
    expect(page).to have_content Game.last.find_players[3].name + " Calls"
    expect(page).to have_content Game.last.find_players[4].name + " Calls"
    expect(page).to have_content Game.last.find_players[0].name + " Calls"
    expect(page).to have_content Game.last.find_players[1].name + " Checks"

    click_on "Deal Flop"
    expect(page).to have_content Game.last.find_players[0].name + " Checks"
    expect(page).to have_content Game.last.find_players[1].name + " Checks"
    expect(page).not_to have_content Game.last.find_players[3].name + " Calls"
    expect(page).not_to have_content Game.last.find_players[4].name + " Calls"

    click_on "Check"
    expect(page).to have_content Game.last.find_players[3].name + " Checks"
    expect(page).to have_content Game.last.find_players[4].name + " Checks"
    expect(page).not_to have_content Game.last.find_players[0].name + " Calls"
    expect(page).not_to have_content Game.last.find_players[1].name + " Calls"

    click_on "Deal Turn"
    expect(page).to have_content Game.last.find_players[0].name + " Checks"
    expect(page).to have_content Game.last.find_players[1].name + " Checks"
    expect(page).not_to have_content Game.last.find_players[3].name + " Calls"
    expect(page).not_to have_content Game.last.find_players[4].name + " Calls"

    click_on "Check"
    expect(page).to have_content Game.last.find_players[3].name + " Checks"
    expect(page).to have_content Game.last.find_players[4].name + " Checks"
    expect(page).not_to have_content Game.last.find_players[0].name + " Calls"
    expect(page).not_to have_content Game.last.find_players[1].name + " Calls"

    click_on "Deal River"
    expect(page).to have_content Game.last.find_players[0].name + " Checks"
    expect(page).to have_content Game.last.find_players[1].name + " Checks"
    expect(page).not_to have_content Game.last.find_players[3].name + " Calls"
    expect(page).not_to have_content Game.last.find_players[4].name + " Calls"

    click_on "Check"
    expect(page).to have_content Game.last.find_players[3].name + " Checks"
    expect(page).to have_content Game.last.find_players[4].name + " Checks"
    expect(page).not_to have_content Game.last.find_players[0].name + " Calls"
    expect(page).not_to have_content Game.last.find_players[1].name + " Calls"

    click_on "Show Winner"

    click_on "Continue"
    expect(Game.last.find_players[3]).to eq User.last
    expect(page).to have_content Game.last.find_players[2].name + " Calls"
    expect(page).not_to have_content Game.last.find_players[4].name + " Calls"
    expect(page).not_to have_content Game.last.find_players[0].name + " Calls"
    expect(page).not_to have_content Game.last.find_players[1].name + " Calls"

    click_on "Call"

    expect(page).to have_content Game.last.find_players[4].name + " Calls"
    expect(page).to have_content Game.last.find_players[0].name + " Calls"
    expect(page).to have_content Game.last.find_players[1].name + " Checks"

    click_on "Deal Flop"

    expect(page).to have_content Game.last.find_players[0].name + " Checks"
    expect(page).to have_content Game.last.find_players[1].name + " Checks"
    expect(page).to have_content Game.last.find_players[2].name + " Checks"
    expect(page).not_to have_content Game.last.find_players[4].name + " Checks"

    click_on "Check"
    expect(page).to have_content Game.last.find_players[4].name + " Checks"
  end
end
