# require "rails_helper"
#
# RSpec.feature "Ai players cannot have less than $0 dollars" do
#   scenario "Ai player is out of the game once they hit $0" do
#     user = User.create(name: "jones", username: "jones", password: "password")
#     ai_player1 = AiPlayer.create(name: "Arnold")
#     ai_player2 = AiPlayer.create(name: "Jackie")
#     ai_player3 = AiPlayer.create(name: "Rosco")
#
#     visit root_path
#
#     click_on "Login"
#     fill_in "Username", with: "jones"
#     fill_in "Password", with: "password"
#     click_button "Login"
#
#     click_on "Play"
#
#     select "4", from: "Player count"
#     select "100", from: "Little blind"
#     select "200", from: "Big blind"
#     click_on "Play Poker"
#
#     expect(Game.last.find_players.first.name).to eq "jones"
#     expect(Game.last.find_players[1].name).to eq "Arnold"
#     expect(User.last.current_bet).to eq 100
#     expect(AiPlayer.find(ai_player1.id).current_bet).to eq 200
#
#     click_on "Call"
#     click_on "Deal Flop"
#     click_on "Check"
#     click_on "Deal Turn"
#     Game.last.find_players.last.update(cash: 100)
#     click_on "Bet / Raise"
#
#     fill_in "Current bet", with: "200"
#     click_on "Submit"
#
#     expect(page).to have_content "Arnold Calls!"
#     expect(page).to have_content "Jackie Calls!"
#     expect(page).to have_content "Rosco Folds"
#
#     click_on "Deal River"
#     click_on "Check"
#     click_on "Show Winner"
#
#     click_on "Continue"
#     expect(page).to have_content "Rosco Folds"
#     expect(Game.last.find_players.first.cash).to eq 0
#     click_on "Check"
#     click_on "Deal Flop"
#     click_on "Check"
#     click_on "Deal Turn"
#     click_on "Check"
#     click_on "Deal River"
#     click_on "Check"
#     click_on "Show Winner"
#
#     expect(Game.last.find_players.count).to eq 4
#     click_on "Continue"
#
#     expect(Game.last.find_players.count).to eq 3
#   end
# end
