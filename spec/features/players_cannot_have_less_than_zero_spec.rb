require "rails_helper"

RSpec.feature "players cannot have less than a zero balance" do
  scenario "ai players cannot be in the negative" do
    User.create(name: "jones", username: "jones", password: "password", cash: 10000)
    AiPlayer.create(name: "Frank")
    AiPlayer.create(name: "Martha")
    AiPlayer.create(name: "Rosco")

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

    click_on "Call"
    click_on "Deal Flop"
    click_on "Check"
    click_on "Deal Turn"
    click_on "Check"
    click_on "Deal River"

    Game.last.players_left.last.update(cash: 50)
    Game.last.find_players.last.update(cards: ["2 of Clubs", "7 of Hearts"])

    flop = ["Ace of Spades", "Ace of Diamonds", "Jack of Clubs"]
    turn = "5 of Hearts"
    river = "10 of Clubs"
    Game.last.update(flop_cards: flop, turn_card: turn, river_card: river)
    Game.last.users.last.update(cards: ["Ace of Clubs", "Ace of Hearts"])
    Game.last.users.last.update(round: 1)
    click_on "Check"

    click_on "Show Winner"
    click_on "Continue"
    expect(page).to have_content "Little Blind: Martha, $100.00"
    expect(page).to have_content "Big Blind: Rosco, $200.00"
    expect(Game.last.players_left[1].name).to eq "Rosco"
    expect(Game.last.players_left[1].cash).not_to eq -150
    expect(Game.last.players_left[1].cash).to eq 00

    click_on "Call"
  end

  scenario "user cannot have less than a zero balance" do
    User.create(name: "jones", username: "jones", password: "password", cash: 10000)
    AiPlayer.create(name: "Frank")
    AiPlayer.create(name: "Martha")

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

    click_on "Call"
    click_on "Deal Flop"
    click_on "Check"
    click_on "Deal Turn"
    click_on "Check"
    click_on "Deal River"

    Game.last.players_left.first.update(cash: 50)
    Game.last.players_left.first.update(cards: ["2 of Clubs", "7 of Hearts"])

    flop = ["Ace of Spades", "Ace of Diamonds", "Jack of Clubs"]
    turn = "5 of Hearts"
    river = "10 of Clubs"
    Game.last.update(flop_cards: flop, turn_card: turn, river_card: river)
    Game.last.players_left.last.update(cards: ["Ace of Clubs", "Ace of Hearts"])
    click_on "Check"

    click_on "Show Winner"
    click_on "Continue"
    expect(page).to have_content "Little Blind: Martha, $100.00"
    expect(page).to have_content "Big Blind: jones, $200.00"
    expect(Game.last.players_left[1].name).to eq "jones"
    expect(Game.last.players_left[1].cash).not_to eq -150
    expect(Game.last.players_left[1].cash).to eq 00

    click_on "Call"
  end
end
