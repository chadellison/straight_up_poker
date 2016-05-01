require "rails_helper"

RSpec.feature "when a player raises all other players must act before moving on" do
  scenario "users call, fold, or raise before the next cards are shown" do
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

    expect(AiPlayer.all.all? { |ai| ai.total_bet == 200 }).to eq true
    click_on "Call"
    click_on "Deal Flop"

    Game.last.find_players[1].update(cash: 200)

    click_on "Bet / Raise"
    fill_in "Current bet", with: "200"
    click_on "Submit"
    expect(page).to have_content "Frank Goes All In ($200)!"
    expect(page).to have_content "Martha Calls!"
    expect(page).to have_content "Rosco Calls!"

    expect(Game.last.find_players[1].cash).to eq 0

    click_on "Deal Turn"

    click_on "Check"

    expect(page).not_to have_content "Frank Checks"
    expect(page).to have_content "Martha Checks"
    expect(page).to have_content "Rosco Checks"

    click_on "Deal River"


    click_on "Check"

    expect(page).not_to have_content "Frank Checks"

    Game.last.find_players[1].update(cards: [["2", "Clubs", "7", "Hearts"]])

    flop = [["ACE", "Spades"], ["ACE", "Diamonds"], ["JACK", "Clubs"]]
    turn = ["5", "Hearts"]
    river = ["10", "Clubs"]
    Game.last.update(flop_cards: flop, turn_card: turn, river_card: river)
    Game.last.users.last.update(cards: [["ACE", "Clubs"], ["ACE", "Hearts"]])

    click_on "Show Winner"

    expect(Game.last.find_players[1].out).to eq false

    click_on "Continue"

    expect(Game.last.find_players[2].out).to eq true
    expect(page).to have_content "Frank: $0.00 OUT"

    expect(page).not_to have_content "Frank Calls!"
    expect(page).to have_content "Martha Calls! Rosco Calls!"

    click_on "Check"

    click_on "Deal Flop"
    click_on "Check"

    click_on "Deal Turn"
    click_on "Check"

    click_on "Deal River"
    click_on "Check"

    flop = [["ACE", "Spades"], ["ACE", "Diamonds"], ["JACK", "Clubs"]]
    turn = ["5", "Hearts"]
    river = ["10", "Clubs"]

    expect(Game.last.find_players[0].name).to eq "Rosco"
    expect(Game.last.find_players[1].name).to eq "jones"
    expect(Game.last.find_players[2].name).to eq "Frank"
    expect(Game.last.find_players[3].name).to eq "Martha"

    Game.last.find_players[0].update(cards: [["5", "Hearts"], ["6", "Clubs"]])
    Game.last.find_players[1].update(cards: [["2", "Hearts"], ["9", "Clubs"]])
    Game.last.find_players[2].update(cards: [["ACE", "Hearts"], ["ACE", "Clubs"]])
    Game.last.find_players[3].update(cards: [["KING", "Hearts"], ["JACK", "Clubs"]])

    Game.last.update(flop_cards: flop, turn_card: turn, river_card: river)

    click_on "Show Winner"

    expect(AiPlayer.find(Game.last.winner.split.first).name).to eq "Martha"
    expect(AiPlayer.find(Game.last.winner.split.first).name).not_to eq "Frank"
  end
end
