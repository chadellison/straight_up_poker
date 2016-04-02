# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
AiPlayer.where(name: "Hillary Clinton", bet_style: "conservative").first_or_create
AiPlayer.where(name: "Donald Trump", bet_style: "aggressive").first_or_create
AiPlayer.where(name: "Bernie Sanders", bet_style: "aggressive").first_or_create
AiPlayer.where(name: "Ted Cruz", bet_style: "conservative").first_or_create
AiPlayer.where(name: "Rosco", bet_style: "aggressive").first_or_create
AiPlayer.where(name: "Oscar", bet_style: "conservative").first_or_create
AiPlayer.where(name: "Martha", bet_style: "conservative").first_or_create
AiPlayer.where(name: "Colbert", bet_style: "conservative").first_or_create
AiPlayer.where(name: "Engrid", bet_style: "aggressive").first_or_create
