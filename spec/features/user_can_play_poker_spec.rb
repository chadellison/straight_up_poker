require "rails_helper"

RSpec.feature "user can play poker" do
  scenario "user sees results of the game" do
    ai = AiPlayer.create(name: "Rosco",
      cash: 1000)

    visit root_path
    click_on "Create Account"
    fill_in "Username", with: "Jones"
    fill_in "Name", with: "Jones Smith"
    fill_in "Email", with: "Jones@gamil.com"
    fill_in "Password", with: "password"
    click_button "Create Account"

    expect(page).to have_content "Welcome Jones"

    click_on "Play"
    expect(new_game_path).to eq current_path

    select "2", from: "Player count"
    select "50", from: "Little blind"
    select "100", from: "Big blind"
    click_on "Play Poker"

    expect(page).to have_content "Opponents: Rosco"
    expect(page).to have_content "Little Blind: Jones Smith, $50.00"
    expect(page).to have_content "Cash: $950.00"
    expect(page).to have_content "Pocket: " + User.last.present_cards

    expect(page).to have_button "Bet / Raise"
    expect(page).to have_button "Call"
    expect(page).to have_button "Fold"
    click_on "Call"
    expect(page).to have_content "Cash: $900.00"
    expect(page).to have_content "Rosco Checks"
    click_on "Deal Flop"

    game = Game.last
    user = User.last
    expect(page).to have_content "Pocket: " + user.present_cards
    expect(page).to have_content "Flop: " + Game.last.flop_cards.join(", ")

    click_on "Check"
    expect(page).to have_content "Rosco Checks"
    click_on "Deal Turn"

    game_w_turn = Game.last

    expect(page).to have_content "Pocket: " + user.present_cards
    expect(page).to have_content "Flop: " + Game.last.flop_cards.join(", ")
    expect(page).to have_content "Turn: " + game_w_turn.turn_card

    click_on "Check"

    expect(page).to have_content "Rosco Checks"
    click_on "Deal River"

    game_w_river = Game.last

    expect(page).to have_content "Pocket: " + user.present_cards
    expect(page).to have_content "Flop: " + Game.last.flop_cards.join(", ")
    expect(page).to have_content "Turn: " + game_w_turn.turn_card
    expect(page).to have_content "River: " + game_w_river.river_card

    click_on "Check"

    expect(page).to have_content "Rosco Checks"
    click_on "Show Winner"
    expect(page).to have_content game.winner
  end
end
