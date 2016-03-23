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
    expect(page).to have_content "Frank Calls"
    click_on "Call"

    click_on "Deal Flop"
    click_on "Check"

    expect(page).to have_content "Mary Checks"
    expect(page).to have_content "Frank Checks"

    click_on "Deal Turn"
    click_on "Check"

    expect(page).to have_content "Mary Checks"
    expect(page).to have_content "Frank Checks"

    click_on "Deal River"
    click_on "Check"

    expect(page).to have_content "Mary Checks"
    expect(page).to have_content "Frank Checks"

    click_on "Show Winner"

    click_on "Continue"
# binding.pry
    expect(Game.last.find_players[0]).to eq AiPlayer.last

    expect(User.last.current_bet).to eq 200
    expect(Game.last.find_players[1]).to eq User.last
    expect(Game.last.find_players[2]).to eq AiPlayer.first
# save_and_open_page
# binding.pry
    expect(page).to have_content "Frank Calls"
    expect(page).to have_content "Mary Calls"
    click_on "Check"

    click_on "Deal Flop"
    click_on "Check"

    expect(page).to have_content "Mary Checks"
    expect(page).to have_content "Frank Checks"

    click_on "Deal Turn"
    click_on "Check"

    expect(page).to have_content "Mary Checks"
    expect(page).to have_content "Frank Checks"

    click_on "Deal River"
    click_on "Check"

    expect(page).to have_content "Mary Checks"
    expect(page).to have_content "Frank Checks"

    click_on "Show Winner"

    click_on "Continue"

    expect(Game.last.find_players[0]).to eq AiPlayer.first

    expect(User.last.current_bet).to eq 0
    expect(Game.last.find_players[1]).to eq AiPlayer.last
    expect(Game.last.find_players[2]).to eq User.last

    click_on "Call"
    expect(page).to have_content "Mary Calls"
    expect(page).to have_content "Frank Checks"

    click_on "Deal Flop"
    click_on "Check"

    expect(page).to have_content "Mary Checks"
    expect(page).to have_content "Frank Checks"

    click_on "Deal Turn"
    click_on "Check"

    expect(page).to have_content "Mary Checks"
    expect(page).to have_content "Frank Checks"

    click_on "Deal River"
    click_on "Check"

    expect(page).to have_content "Mary Checks"
    expect(page).to have_content "Frank Checks"

    click_on "Show Winner"

    click_on "Continue"
  end
end
