# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
AiPlayer.where(name: "Jones").first_or_create
AiPlayer.where(name: "Donald Trump").first_or_create
AiPlayer.where(name: "Hg man").first_or_create
