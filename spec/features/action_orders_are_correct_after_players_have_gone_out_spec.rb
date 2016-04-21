require "rails_helper"

RSpec.feature "when a player they are out" do
  scenario "user sees correct action rotation without the players who are out" do
    User.create(name: "jones", username: "jones", password: "password", cash: 10000)
    AiPlayer.create(name: "Frank")
    AiPlayer.create(name: "Martha")
    AiPlayer.create(name: "Rosco")
    AiPlayer.create(name: "Zoe")

    visit root_path
    click_on "Login"
    fill_in "Username", with: "jones"
    fill_in "Password", with: "password"
    click_button "Login"

    click_on "Play"
    select "5", from: "Player count"
    select "100", from: "Little blind"
    select "200", from: "Big blind"
    click_on "Play Poker"

    Game.last.find_players.each { |player| player.update(cash: 10000) }

    click_on "Call"
    click_on "Deal Flop"

    Game.last.find_players[1].update(cash: 200)
    Game.last.find_players[4].update(cash: 200)

    click_on "Bet / Raise"
    fill_in "Current bet", with: "200"
    click_on "Submit"
    expect(page).to have_content "Frank Goes All In ($200)!"
    expect(page).to have_content "Martha Calls!"
    expect(page).to have_content "Rosco Calls!"
    expect(page).to have_content "Zoe Goes All In ($200)!"

    expect(Game.last.find_players[1].cash).to eq 0
    expect(Game.last.find_players[4].cash).to eq 0

    click_on "Deal Turn"

    click_on "Check"

    expect(page).not_to have_content "Frank Checks"
    expect(page).not_to have_content "Zoe Checks"
    expect(page).to have_content "Martha Checks"
    expect(page).to have_content "Rosco Checks"

    click_on "Deal River"

    click_on "Check"

    Game.last.find_players[1].update(cards: ["2 of Clubs", "7 of Hearts"])
    Game.last.find_players[4].update(cards: ["4 of Clubs", "9 of Hearts"])

    flop = ["Ace of Spades", "Ace of Diamonds", "Jack of Clubs"]
    turn = "5 of Hearts"
    river = "10 of Clubs"
    Game.last.update(flop_cards: flop, turn_card: turn, river_card: river)
    Game.last.users.last.update(cards: ["Ace of Clubs", "Ace of Hearts"])

    click_on "Show Winner"

    click_on "Continue"

    expect(Game.last.find_players[0].name).to eq "Zoe" #out
    expect(Game.last.find_players[1].name).to eq "jones"
    expect(Game.last.find_players[2].name).to eq "Frank" #out
    expect(Game.last.find_players[3].name).to eq "Martha"
    expect(Game.last.find_players[4].name).to eq "Rosco"

    # Rosco jones Martha
    expect(Game.last.players_left[0].name).to eq "Rosco"
    expect(Game.last.players_left[1].name).to eq "jones"
    expect(Game.last.players_left[2].name).to eq "Martha"

    expect(page).to have_content "Frank: $0.00 OUT"
    expect(page).to have_content "Zoe: $0.00 OUT"
    expect(page).to have_content "Little Blind: Rosco, $100.00"
    expect(page).to have_content "Big Blind: jones, $200.00"

    expect(page).to have_content "Martha Calls! Rosco Calls!"

    click_on "Check"

    click_on "Deal Flop"

    expect(page).to have_content "Rosco Checks"
    expect(page).not_to have_content "Martha Checks"

    click_on "Check"
    expect(page).to have_content "Martha Checks"

    click_on "Deal Turn"
    click_on "Check"

    click_on "Deal River"
    click_on "Check"

    click_on "Show Winner"

    click_on "Continue"

    expect(Game.last.find_players[0].name).to eq "Rosco"
    expect(Game.last.find_players[1].name).to eq "Zoe" #out
    expect(Game.last.find_players[2].name).to eq "jones"
    expect(Game.last.find_players[3].name).to eq "Frank" #out
    expect(Game.last.find_players[4].name).to eq "Martha"

    expect(Game.last.players_left[0].name).to eq "Martha"
    expect(Game.last.players_left[1].name).to eq "Rosco"
    expect(Game.last.players_left[2].name).to eq "jones"

    # Martha Rosco Jones
    # all players: rosco (zoe) jones (frank) martha

    expect(page).to have_content "Little Blind: Martha, $100.00"
    expect(page).to have_content "Big Blind: Rosco, $200.00"

    expect(page).not_to have_content "Martha Calls!"
    expect(page).not_to have_content "Rosco Checks"

    click_on "Call"

    expect(page).to have_content "Martha Calls! Rosco Checks"

    click_on "Deal Flop"

    click_on "Check"

    click_on "Deal Turn"

    expect(page).to have_content "Martha Checks Rosco Checks"

    click_on "Check"

    click_button "Deal River"

    expect(Game.last.find_players[0].name).to eq "Rosco"
    expect(Game.last.find_players[4].name).to eq "Martha"

    Game.last.find_players[0].update(cash: 200)
    click_on "Bet / Raise"
    fill_in "Current bet", with: "200"
    click_on "Submit"

    expect(page).not_to have_content "Frank Goes All In ($200)!"
    expect(page).to have_content "Martha Calls!"
    expect(page).to have_content "Rosco Goes All In ($200)!"

    Game.last.find_players[0].update(cards: ["4 of Clubs", "9 of Hearts"])

    flop = ["Ace of Spades", "Ace of Diamonds", "Jack of Clubs"]
    turn = "5 of Hearts"
    river = "10 of Clubs"
    Game.last.update(flop_cards: flop, turn_card: turn, river_card: river)
    Game.last.users.last.update(cards: ["Ace of Clubs", "Ace of Hearts"])

    click_on "Show Winner"

    click_on "Continue"

    # jones Martha

    expect(Game.last.players_left.count).to eq 2

    expect(page).to have_content "Rosco: $0.00 OUT"

    expect(page).to have_content "Little Blind: jones, $100.00"
    expect(page).to have_content "Big Blind: Martha, $200.00"
    expect(page).not_to have_content "Martha Checks"

    click_on "Call"

    expect(page).to have_content "Martha Checks"

    click_on "Deal Flop"
    expect(page).not_to have_content "Martha Checks"

    click_on "Check"

    expect(page).to have_content "Martha Checks"

    click_on "Deal Turn"

    click_on "Check"

    click_on "Deal River"

    click_on "Check"

    click_on "Show Winner"

    click_on "Continue"
    expect(page).to have_content "Little Blind: Martha, $100.00"
    expect(page).to have_content "Big Blind: jones, $200.00"

    expect(page).to have_content "Martha Calls!"

    click_on "Check"

    click_on "Deal Flop"
    expect(page).to have_content "Martha Checks"
  end

  scenario "correct rotations are maintained when the first and fifth go out" do
    User.create(name: "jones", username: "jones", password: "password", cash: 10000)
    AiPlayer.create(name: "Bill")
    AiPlayer.create(name: "Frank")
    AiPlayer.create(name: "Martha")
    AiPlayer.create(name: "Rosco")
    AiPlayer.create(name: "Zoe")

    visit root_path
    click_on "Login"
    fill_in "Username", with: "jones"
    fill_in "Password", with: "password"
    click_button "Login"

    click_on "Play"
    select "6", from: "Player count"
    select "100", from: "Little blind"
    select "200", from: "Big blind"
    click_on "Play Poker"

    Game.last.find_players.each { |player| player.update(cash: 10000) }

    click_on "Call"
    click_on "Deal Flop"
    click_on "Check"
    click_on "Deal Turn"
    click_on "Check"
    click_on "Deal River"
    click_on "Check"

    Game.last.users.last.update(round: 3)

    click_on "Show Winner"

    click_on "Continue"

    expect(Game.last.find_players[0].name).to eq "Frank"
    expect(Game.last.find_players[1].name).to eq "Martha"
    expect(Game.last.find_players[2].name).to eq "Rosco"
    expect(Game.last.find_players[3].name).to eq "Zoe"
    expect(Game.last.find_players[4].name).to eq "jones"
    expect(Game.last.find_players[5].name).to eq "Bill"

    click_on "Call"

    click_on "Deal Flop"

    Game.last.find_players[1].update(cash: 200)
    Game.last.find_players[5].update(cash: 200)

    click_on "Bet / Raise"
    fill_in "Current bet", with: "200"
    click_on "Submit"

    expect(page).to have_content "Martha Goes All In ($200)!"
    expect(page).to have_content "Bill Goes All In ($200)!"

    click_on "Deal Turn"
    click_on "Check"
    click_on "Deal River"
    click_on "Check"

    flop = ["Jack of Spades", "Jack of Clubs", "10 of Hearts"]
    turn = ["Ace of Diamonds"]
    river = ["4 of Clubs"]

    Game.last.find_players[1].update(cards: ["5 of Hearts", "2 of Spades"])
    Game.last.find_players[5].update(cards: ["5 of Spades", "2 of Hearts"])
    Game.last.find_players[0].update(cards: ["Jack of Diamonds", "Jack of Hearts"])

    click_on "Show Winner"

    click_on "Continue"

    expect(Game.last.players_left[0].name).to eq "jones"
    expect(Game.last.players_left[1].name).to eq "Frank"
    expect(Game.last.players_left[2].name).to eq "Rosco"
    expect(Game.last.players_left[3].name).to eq "Zoe"
  end

  scenario "correct rotations are maintained when the first and fifth go out" do
    User.create(name: "jones", username: "jones", password: "password", cash: 10000)
    AiPlayer.create(name: "Bill")
    AiPlayer.create(name: "Frank")
    AiPlayer.create(name: "Martha")
    AiPlayer.create(name: "Rosco")
    AiPlayer.create(name: "Zoe")

    visit root_path
    click_on "Login"
    fill_in "Username", with: "jones"
    fill_in "Password", with: "password"
    click_button "Login"

    click_on "Play"
    select "6", from: "Player count"
    select "100", from: "Little blind"
    select "200", from: "Big blind"
    click_on "Play Poker"

    Game.last.find_players.each { |player| player.update(cash: 10000) }

    click_on "Call"
    click_on "Deal Flop"
    click_on "Check"
    click_on "Deal Turn"
    click_on "Check"
    click_on "Deal River"

    Game.last.find_players.last.update(cash: 200)
    click_on "Bet / Raise"
    fill_in "Current bet", with: "200"
    click_on "Submit"

    Game.last.find_players.last.update(cards: ["4 of Clubs", "9 of Hearts"])

    flop = ["Ace of Spades", "Ace of Diamonds", "Jack of Clubs"]
    turn = "5 of Hearts"
    river = "10 of Clubs"
    Game.last.update(flop_cards: flop, turn_card: turn, river_card: river)
    Game.last.users.last.update(cards: ["Ace of Clubs", "Ace of Hearts"])

    expect(Game.last.find_players.last.cash).to eq 0

    click_on "Show Winner"

    click_on "Continue"

    expect(Game.last.players_left[0].name).to eq "Rosco"
    expect(Game.last.players_left[1].name).to eq "jones"
    expect(Game.last.players_left[2].name).to eq "Bill"
    expect(Game.last.players_left[3].name).to eq "Frank"
    expect(Game.last.players_left[4].name).to eq "Martha"

    expect(page).to have_content "Little Blind: Rosco, $100.00"
    expect(page).to have_content "Big Blind: jones, $200.00"

    expect(page).to have_content "Bill Calls! Frank Calls! Martha Calls! Rosco Calls!"

    click_on "Check"
    click_on "Deal Flop"
    click_on "Check"
    click_on "Deal Turn"
    Game.last.players_left[0].update(cash: 200)


    click_on "Bet / Raise"
    fill_in "Current bet", with: "200"
    click_on "Submit"

    expect(page).to have_content "Bill Calls! Frank Calls! Martha Calls!"

    click_on "Deal River"
    click_on "Check"

    flop = ["Jack of Spades", "Jack of Clubs", "10 of Hearts"]
    turn = ["Ace of Diamonds"]
    river = ["4 of Clubs"]

    Game.last.players_left[0].update(cards: ["5 of Hearts", "2 of Spades"])
    Game.last.players_left[3].update(cards: ["Jack of Hearts", "Jack of Diamonds"])

    click_on "Show Winner"

    click_on "Continue"
    expect(page).to have_content "Little Blind: Frank, $100.00"
    expect(page).to have_content "Big Blind: Martha, $200.00"

    expect(page).not_to have_content "Bill Calls!"
    click_on "Call"

    click_on "Deal Flop"

    Game.last.players_left.last.update(cash: 200)
    Game.last.players_left.first.update(cash: 200)

    click_on "Bet / Raise"
    fill_in "Current bet", with: 200
    click_on "Submit"

    expect(page).to have_content "Bill Goes All In ($200)!"
    expect(page).to have_content "Frank Goes All In ($200)!"
    expect(page).to have_content "Martha Calls!"

    click_on "Deal Turn"
    expect(page).to have_content "Martha Checks"
    click_on "Check"
    click_on "Deal River"
    click_on "Check"

    flop = ["Queen of Spades", "Queen of Clubs", "10 of Hearts"]
    turn = ["Ace of Diamonds"]
    river = ["4 of Clubs"]

    Game.last.players_left.first.update(cards: ["5 of Hearts", "2 of Spades"])
    Game.last.players_left.last.update(cards: ["2 of Hearts", "7 of Spades"])
    Game.last.users.last.update(cards: ["Queen of Hearts", "Queen of Diamonds"])

    click_on "Show Winner"

    click_on "Continue"
    expect(page).to have_content "Little Blind: Martha, $100.00"
    expect(page).to have_content "Big Blind: jones, $200.00"
  end
end
