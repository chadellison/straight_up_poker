require "rails_helper"

RSpec.feature "user can fold vs multiple ais" do
  scenario "user sees the remainder of the game" do
    AiPlayer.create(name: "Frank")
    AiPlayer.create(name: "Mary")
    AiPlayer.create(name: "Rosco")
    User.create(name: "jones", username: "jones", password: "password")

    visit root_path
    click_on "Login"
    fill_in "Username", with: "jones"
    fill_in "Password", with: "password"
    click_button "Login"

    click_on "Play"
    select "4", from: "Player count"
    select "100", from: "Little blind"
    select "200", from: "Big blind"
    click_on "Play Poker"

    refute Game.last.winner

    click_on "Fold"
    expect(page).to have_content "Frank Checks"
    expect(page).not_to have_content "Mary Checks Rosco Checks"
    click_on "Deal Flop"

    expect(page).to have_content "Frank Checks Mary Checks Rosco Checks"
    click_on "Deal Turn"
    expect(page).to have_content "Frank Checks Mary Checks Rosco Checks"
    click_on "Deal River"
    expect(page).to have_content "Frank Checks Mary Checks Rosco Checks"
    click_on "Show Winner"
    assert Game.last.winner

    click_on "Continue"
  end

  scenario "All ai players are updated when one of them bets and user has folded" do
    AiPlayer.create(name: "Frank")
    AiPlayer.create(name: "Mary", bet_style: "always raise")
    AiPlayer.create(name: "Rosco", bet_style: "always raise")
    User.create(name: "jones", username: "jones", password: "password")

    visit root_path
    click_on "Login"
    fill_in "Username", with: "jones"
    fill_in "Password", with: "password"
    click_button "Login"

    click_on "Play"
    select "4", from: "Player count"
    select "10", from: "Little blind"
    select "20", from: "Big blind"
    click_on "Play Poker"
    #jones Frank Mary Rosco

    Game.last.find_players.each { |player| player.update(cash: 10000) }

    expect(page).to have_content "Mary Raises $20.00 Rosco Raises $20.00"
    expect(page).not_to have_content "Frank Calls!"

    click_on "Fold"

    expect(page).to have_content "Frank Calls! Mary Raises $20.00 Rosco Calls! Frank Calls!"

    click_on "Deal Flop"
    expect(page).to have_content "Frank Checks Mary Raises $20.00 Rosco Raises $20.00 Frank Calls! Mary Raises $20.00 Rosco Calls! Frank Calls!"

    click_on "Deal Turn"

    expect(page).to have_content "Frank Checks Mary Raises $20.00 Rosco Raises $20.00 Frank Calls! Mary Raises $20.00 Rosco Calls! Frank Calls!"

    click_on "Deal River"

    expect(page).to have_content "Frank Checks Mary Raises $20.00 Rosco Raises $20.00 Frank Calls! Mary Raises $20.00 Rosco Calls! Frank Calls!"

    click_on "Show Winner"

    click_on "Continue"

    # Rosco jones Frank Mary

    expect(page).to have_content "Frank Calls! Mary Raises $20.00 Rosco Raises $20.00"
    click_on "Call"

    expect(page).to have_content "Frank Calls! Mary Raises $20.00 Rosco Calls!"
    click_on "Call"

    expect(page).to have_content "Frank Calls!"
    click_on "Deal Flop"

    expect(page).to have_content "Rosco Raises $20.00"
    click_on "Call"

    expect(page).to have_content "Frank Calls! Mary Raises $20.00 Rosco Raises $20.00"

    click_on "Call"
    expect(page).to have_content "Frank Calls! Mary Calls!"
    click_on "Deal Turn"
    expect(page).to have_content "Rosco Raises $20.00"

    click_on "Fold"

    expect(page).to have_content "Frank Calls! Mary Raises $20.00 Rosco Raises $20.00 Frank Calls! Mary Calls!"

    click_on "Deal River"

    expect(page).to have_content "Rosco Raises $20.00 Frank Calls! Mary Raises $20.00 Rosco Raises $20.00 Frank Calls! Mary Calls!"
    click_on "Show Winner"

    click_on "Continue"

    # Mary Rosco jones Frank

    click_on "Call"

    expect(page).to have_content "Frank Calls! Mary Raises $20.00 Rosco Raises $20.00"

    click_on "Call"
    expect(page).to have_content "Frank Calls! Mary Raises $20.00 Rosco Calls!"

    click_on "Call"
    expect(page).to have_content "Frank Calls!"

    click_on "Deal Flop"

    expect(page).to have_content "Mary Raises $20.00 Rosco Raises $20.00"
    expect(page).not_to have_content "Frank Calls!"

    click_on "Fold"
    expect(page).to have_content "Frank Calls! Mary Raises $20.00 Rosco Calls! Frank Calls!"
    click_on "Deal Turn"
    expect(page).to have_content "Mary Raises $20.00 Rosco Raises $20.00 Frank Calls! Mary Raises $20.00 Rosco Calls! Frank Calls!"
    click_on "Deal River"
    click_on "Show Winner"

    click_on "Continue"

    # Frank Mary Rosco jones

    expect(page).to have_content "Rosco Raises $20.00"
    expect(page).not_to have_content "Frank Calls! Mary Raises $20.00"

    click_on "Call"

    expect(page).to have_content "Frank Calls! Mary Raises $20.00 Rosco Raises $20.00"
    click_on "Call"
    expect(page).to have_content "Frank Calls! Mary Calls!"

    click_on "Deal Flop"

    expect(page).to have_content "Frank Checks Mary Raises $20.00 Rosco Raises $20.00"
    click_on "Call"
    expect(page).to have_content "Frank Calls! Mary Raises $20.00 Rosco Calls!"
    click_on "Fold"

    expect(page).to have_content "Frank Calls!"

    click_on "Deal Turn"

    expect(page).to have_content "Frank Checks Mary Raises $20.00 Rosco Raises $20.00 Frank Calls! Mary Raises $20.00 Rosco Calls! Frank Calls!"

    click_on "Deal River"
    click_on "Show Winner"

    click_on "Continue"
  end
end
