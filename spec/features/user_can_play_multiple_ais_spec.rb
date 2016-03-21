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

    expect(Game.last.all_players[-2]).to eq User.last
    expect(page).to have_content "Martha Calls!"
    click_on "Call"
    expect(User.last.cash).to eq 900
# save_and_open_page
    expect(page).to have_content "Mary Calls"
    expect(page).to have_content "Frank Calls"
    expect(page).to have_content "Oscar Checks"

    click_on "Deal Flop"
    click_on "Fold"

    expect(page).to have_content "Mary Checks"
    expect(page).to have_content "Frank Checks"
    expect(page).to have_content "Oscar Checks"
    expect(page).to have_content "Martha Checks"

    expect(page).to have_content Game.last.winner

    click_on "Continue"

    expect(Game.last.all_players[-3]).to eq User.last
    expect(User.last.cash).to eq 800
    expect(page).to have_content "Mary Calls"
    expect(page).to have_content "Frank Calls"
    expect(page).to have_content "Oscar Calls"
    expect(page).to have_content "Martha Calls"

    click_on "Check"

    click_on "Deal Flop"
  end
end
