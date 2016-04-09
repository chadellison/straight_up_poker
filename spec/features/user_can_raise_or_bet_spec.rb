require "rails_helper"

RSpec.feature "user can raise or bet" do
  scenario "user sees ai's response to bet" do
    user = User.create(name: "Oscar", username: "oscar", password: "password")
    ai_player = AiPlayer.create(name: "Rosco")

    visit root_path

    click_on "Login"
    fill_in "Username", with: "oscar"
    fill_in "Password", with: "password"
    click_on "Login"

    click_on "Play"

    select "2", from: "Player count"
    select "100", from: "Little blind"
    select "200", from: "Big blind"
    click_on "Play Poker"

    click_button "Bet / Raise"
    expect(page).to have_content "How much would you like to bet?"
    fill_in "Current bet", with: "200"
    click_on "Submit"

    expect(page).to have_content "Rosco Calls!"
    expect(User.last.cash).to eq 700
    expect(AiPlayer.last.cash).to eq 700
    expect(Game.last.pot).to eq 600
  end

  scenario "user sees each player respond to raise" do
    User.create(name: "jones", username: "jones", password: "password")
    ai_player1 = AiPlayer.create(name: "Frank")
    ai_player2 = AiPlayer.create(name: "Martha")
    ai_player3 = AiPlayer.create(name: "Rosco")
    ai_player4 = AiPlayer.create(name: "Zoe")

    # jones Frank Martha Rosco Zoe

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

    expect(page).to have_content "Martha Calls! Rosco Calls! Zoe Calls!"
    click_on "Call"

    expect(page).to have_content "Frank Checks"

    click_on "Deal Flop"

    click_on "Bet / Raise"
    fill_in "Current bet", with: "100"
    click_on "Submit"

    expect(page).to have_content "Frank Calls! Martha Calls! Rosco Calls! Zoe Calls!"
    click_on "Deal Turn"
    click_on "Check"
    click_on "Deal River"
    click_on "Check"
    click_on "Show Winner"

    click_on "Continue"

    # Zoe jones Frank Martha Rosco

    expect(page).to have_content "Frank Calls! Martha Calls! Rosco Calls! Zoe Calls!"
    click_on "Check"
    click_on "Deal Flop"
    click_on "Check"
    click_on "Deal Turn"
    click_on "Check"
    click_on "Deal River"
    expect(page).to have_content "Zoe Checks"
    expect(page).not_to have_content "Martha Checks! Rosco Checks! Zoe Checks!"
    click_on "Bet / Raise"
    fill_in "Current bet", with: "100"
    click_on "Submit"
    expect(page).to have_content "Frank Calls! Martha Calls! Rosco Calls! Zoe Calls!"
    click_on "Show Winner"

    click_on "Continue"

    expect(page).not_to have_content "Frank Calls! Martha Calls!"
    click_on "Call"
    expect(page).to have_content "Frank Calls! Martha Calls! Rosco Calls! Zoe Checks"
    click_on "Deal Flop"
    click_on "Check"
    click_on "Deal Turn"
    click_on "Check"
    click_on "Deal River"

    expect(page).to have_content "Rosco Checks Zoe Checks"
    expect(page).not_to have_content "Frank Checks! Martha Checks!"
    click_on "Bet / Raise"
    fill_in "Current bet", with: "100"
    click_on "Submit"
    expect(page).to have_content "Frank Calls! Martha Calls! Rosco Calls! Zoe Calls!"
    click_on "Show Winner"

    click_on "Continue"

# Martha Rosco Zoe Jones Frank

    expect(page).to have_content "Zoe Calls!"
    click_on "Call"
    expect(page).to have_content "Frank Calls! Martha Calls! Rosco Checks"
    click_on "Deal Flop"
    click_on "Check"
    click_on "Deal Turn"
    click_on "Check"
    click_on "Deal River"
    expect(page).to have_content "Martha Checks Rosco Checks Zoe Checks"
    expect(page).not_to have_content "Frank Checks!"
    click_on "Bet / Raise"
    fill_in "Current bet", with: "100"
    click_on "Submit"
    expect(page).to have_content "Frank Calls! Martha Calls! Rosco Calls! Zoe Calls!"
    click_on "Show Winner"

    click_on "Continue"

# Frank Martha Rosco Zoe Jones

    expect(page).to have_content "Rosco Calls! Zoe Calls!"
    click_on "Call"
    expect(page).to have_content "Frank Calls! Martha Checks"
    click_on "Deal Flop"
    click_on "Check"
    click_on "Deal Turn"
    expect(page).to have_content "Frank Checks Martha Checks Rosco Checks Zoe Checks"
    click_on "Bet / Raise"
    fill_in "Current bet", with: "100"
    click_on "Submit"

    expect(page).to have_content "Frank Calls! Martha Calls! Rosco Calls! Zoe Calls!"
    click_on "Deal River"
    click_on "Check"
    click_on "Show Winner"
  end
end
