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
    click_on "Login"

    click_on "Play"

    select "3", from: "Player count"
    select "100", from: "Little blind"
    select "200", from: "Big blind"
    click_on "Play Poker"

    ace1 = "Ace of Hearts"
    ace2 = "Ace of Clubs"

    two = "2 of Clubs"
    seven = "7 of Clubs"

    Game.last.ai_players.last.name == "Rick"
    Game.last.ai_players.first.name == "Frankie"
    Game.last.ai_players.last.update(cards: [ace1, ace2])
    Game.last.ai_players.first.update(cards: [two, seven])

    expect(page).to have_content "Rick folds!"

    click_on "Call"
    click_on "Deal Flop"
    click_on "Check"
    click_on "Deal Turn"
    click_on "Check"
    click_on "Deal River"

    click_on "Check"

    flop1 = "Ace of Diamonds"
    flop2 = "Ace of Spades"
    flop3 = "7 of Spades"

    turn = "10 of Spades"

    river = "2 of Spades"

    user_card = "9 of Hearts"
    user_card2 = "Jack of Hearts"

    Game.last.update(flop_cards: [flop1, flop2, flop3])
    Game.last.update(turn_card: turn)
    Game.last.update(river_card: river)

    User.last.update(cards: [user_card, user_card2])

    click_on "Show Winner"

    expect(page).not_to have_content "Rick wins!"
    expect(page).to have_content "Frankie wins!"
  end
end
