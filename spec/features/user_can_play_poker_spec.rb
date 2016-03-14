require "rails_helper"

RSpec.feature "user can play poker" do
  scenario "user sees results of the game" do
    ai = AiPlayer.create(name: "Rosco",
      skill: 1,
      bet_style: "overly_safe",
      cash: 1000)

    visit root_path
    click_on "Create Account"
    fill_in "Username", with: "Jones"
    fill_in "Name", with: "Jones Smith"
    fill_in "Email", with: "Jones@gamil.com"
    fill_in "Password", with: "password"
    click_on "Create Account"

    expect(page).to have_content "Welcome Jones"

    click_on "Play"
    expect(new_game_path).to eq current_path

    select "2", from: "Player count"
    select "50", from: "Little blind"
    select "100", from: "Big blind"
    click_on "Play Poker"

    expect(page).to have_content "Opponents: Rosco"
    expect(page).to have_content "Little Blind: $50.00"
    expect(page).to have_content "Cash: $950.00"
    expect(page).to have_content "Pocket Cards: " + User.last.pocket_cards

    expect(page).to have_button "Raise"
    expect(page).to have_button "Call"
    expect(page).to have_button "Check"
    expect(page).to have_button "Fold"

    click_on "Call"
    expect(page).to have_content "Cash: $900.00"
    expect(page).to have_content "Rosco Checks"
    expect(page).to have_content "Flop: " + Game.last.flop
    expect(page).to have_content "Pocket Cards: " + user.pocket_cards

    click_on "Check"

    expect(page).to have_content "Rosco Checks"
    expect(page).to have_content "Turn: #{Game.last.turn Game.last.flop}"

    click_on "Check"

    expect(page).to have_content "Rosco Checks"

    expect(page).to have_content "River: #{Game.last.river Game.last.flop}"

    click_on "Check"

    expect(page).to have_content "Rosco Checks"
    expect(page).to have_content "#{Game.last.winner} wins!"
  end
end
