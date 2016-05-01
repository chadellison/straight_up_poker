require "rails_helper"

RSpec.feature "ai players fold depending on the circumstances" do
  scenario "ai player is no longer part of the round" do
    user = User.create(name: "jones", username: "jones", password: "password")
    ai_player = AiPlayer.create(name: "Frankie")
    ai_player2 = AiPlayer.create(name: "Rick", bet_style: "always fold")

    visit root_path
    click_on "Login"
    fill_in "Username", with: "jones"
    fill_in "Password", with: "password"
    click_button "Login"

    click_on "Play"

    select "3", from: "Player count"
    select "100", from: "Little blind"
    select "200", from: "Big blind"
    click_on "Play Poker"

    ace1 = ["ACE", "Hearts"]
    ace2 = ["ACE", "Clubs"]

    two = ["2", "Clubs"]
    seven = ["7", "Clubs"]

    Game.last.find_players.last.name == "Rick"
    Game.last.find_players[1].name == "Frankie"
    Game.last.find_players.last.update(cards: [ace1, ace2])
    Game.last.find_players[1].update(cards: [two, seven])

    expect(page).to have_content "Rick Folds"

    click_on "Call"
    click_on "Deal Flop"
    click_on "Check"
    click_on "Deal Turn"
    click_on "Check"
    click_on "Deal River"

    click_on "Check"

    flop1 = ["ACE", "Diamonds"]
    flop2 = ["ACE", "Spades"]
    flop3 = ["7", "Spades"]

    turn = ["10", "Spades"]

    river = ["2", "Spades"]

    user_card = ["9", "Hearts"]
    user_card2 = ["JACK", "Hearts"]

    Game.last.update(flop_cards: [flop1, flop2, flop3])
    Game.last.update(turn_card: turn)
    Game.last.update(river_card: river)

    User.last.update(cards: [user_card, user_card2])
    click_on "Show Winner"

    expect(page).not_to have_content "Rick wins with a Full House!"
    expect(page).to have_content "Frankie wins with a Two Pair!"
  end

  scenario "ai players who fold are no longer part of the round" do
    user = User.create(name: "jones", username: "jones", password: "password")
    ai_player1 = AiPlayer.create(name: "Frankie", bet_style: "always fold")
    ai_player2 = AiPlayer.create(name: "Martha")
    ai_player3 = AiPlayer.create(name: "Rick", bet_style: "always fold")
    ai_player4 = AiPlayer.create(name: "Zoe", bet_style: "always fold")

    visit root_path

    click_on "Login"
    fill_in "Username", with: "jones"
    fill_in "Password", with: "password"
    click_button "Login"

    click_on "Play"

    select "5", from: "Player count"
    select "10", from: "Little blind"
    select "20", from: "Big blind"
    click_on "Play Poker"

    expect(page).to have_content "Martha Calls! Rick Folds Zoe Folds"
    expect(page).not_to have_content "Frankie Folds!"

    click_on "Call"

    expect(page).to have_content "Frankie Checks"

    click_on "Deal Flop"
    click_on "Check"

    expect(page).not_to have_content "Rick Checks Zoe Checks"
    expect(page).to have_content "Frankie Checks Martha Checks"

    click_on "Deal Turn"
    click_on "Check"

    expect(page).not_to have_content "Rick Checks Zoe Checks"
    expect(page).to have_content "Frankie Checks Martha Checks"

    click_on "Deal River"
    click_on "Bet / Raise"

    fill_in "Current bet", with: "100"
    click_on "Submit"

    expect(page).not_to have_content "Rick Checks Zoe Checks"
    expect(page).to have_content "Frankie Folds Martha Calls!"

    click_on "Show Winner"

    click_on "Continue"
    expect(page).to have_content "Frankie Folds Martha Calls! Rick Folds Zoe Folds"

    click_on "Check"
    click_on "Deal Flop"

    expect(page).not_to have_content "Zoe Folds"
    click_on "Check"
    expect(page).not_to have_content "Frankie Folds Rick Folds"
    expect(page).to have_content "Martha Checks"
  end
end
