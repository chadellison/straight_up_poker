# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
AiPlayer.where(name: "Hillary Clinton", bet_style: "conservative").first_or_create
AiPlayer.where(name: "Donald Trump", bet_style: "conservative").first_or_create
AiPlayer.where(name: "Bernie Sanders").first_or_create
AiPlayer.where(name: "Ted Cruz").first_or_create
AiPlayer.where(name: "Rosco").first_or_create
AiPlayer.where(name: "Oscar").first_or_create
AiPlayer.where(name: "Martha").first_or_create
AiPlayer.where(name: "Colbert").first_or_create
AiPlayer.where(name: "Engrid").first_or_create
