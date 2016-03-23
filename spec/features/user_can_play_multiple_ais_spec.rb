require "rails_helper"

RSpec.feature "user can play multiple ais" do
  scenario "user sees blind rotation and actions of each ai" do
    AiPlayer.create(name: "Mary")
    AiPlayer.create(name: "Frank")
    AiPlayer.create(name: "Oscar")
    AiPlayer.create(name: "Martha")
    User.create(name: "jones", username: "jones", password: "password")

    visit root_path
    click_on "Login"
    fill_in "Username", with: "jones"
    fill_in "Password", with: "password"
    click_on "Login"

    click_on "Play"
    select "5", from: "Player count"
    select "50", from: "Little blind"
    select "100", from: "Big blind"
    click_on "Play Poker"

    expect(Game.last.find_players[0]).to eq User.last

    expect(User.last.cash).to eq 950
    expect(Game.last.find_players[1].cash).to eq 900
    expect(page).to have_content "Frank Calls!"
    expect(page).to have_content "Oscar Calls!"
    expect(page).to have_content "Martha Calls!"
    click_on "Call"
    expect(page).to have_content "Mary Checks"

    click_on "Deal Flop"
    click_on "Check"

    expect(page).to have_content "Mary Checks"
    expect(page).to have_content "Frank Checks"
    expect(page).to have_content "Oscar Checks"
    expect(page).to have_content "Martha Checks"

    click_on "Deal Turn"

    click_on "Bet / Raise"
    fill_in "Current bet", with: "200"
    click_on "Submit"

    expect(page).to have_content "Mary Calls!"
    expect(page).to have_content "Frank Calls!"
    expect(page).to have_content "Oscar Calls!"
    expect(page).to have_content "Martha Calls!"

    click_on "Deal River"

    click_on "Check"

    expect(page).to have_content "Mary Checks"
    expect(page).to have_content "Frank Checks"
    expect(page).to have_content "Oscar Checks"
    expect(page).to have_content "Martha Checks"

    refute Game.last.winner

    click_on "Show Winner"

    assert Game.last.winner

    expect(Game.last.find_players.first).to eq User.last

    click_on "Continue"

    expect(Game.last.find_players[1]).to eq User.last
  end
end
