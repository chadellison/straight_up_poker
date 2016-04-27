# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
AiPlayer.where(name: "Donald Trump", bet_style: "aggressive",
  avatar: "http://static4.businessinsider.com/image/559e9efe6bb3f72c54679458/donald-trump-has-surged-to-the-top-of-2-new-2016-polls.jpg").first_or_create
AiPlayer.where(name: "Hillary Clinton", bet_style: "conservative",
  avatar: "http://a4.files.biography.com/image/upload/c_fill,cs_srgb,dpr_1.0,g_face,h_300,q_80,w_300/MTE4MDAzNDEwMDU4NTc3NDIy.jpg").first_or_create
AiPlayer.where(name: "Bernie Sanders", bet_style: "aggressive",
  avatar: "http://images.huffingtonpost.com/2016-02-22-1456172662-1597066-BernieSanders.jpg").first_or_create
AiPlayer.where(name: "Ted Cruz", bet_style: "conservative",
  avatar: "http://cdn.theatlantic.com/assets/media/img/mt/2015/07/AP_473596995531/lead_960.jpg?1437760759").first_or_create
AiPlayer.where(name: "Rosco", bet_style: "aggressive",
  avatar: "http://2.bp.blogspot.com/-EV8quqNoyeE/VSva252zcvI/AAAAAAAAIK4/ByqTJ2j8Tt0/s1600/ROSCO%2B1.jpg").first_or_create
AiPlayer.where(name: "Oscar", bet_style: "conservative",
  avatar: "http://orig07.deviantart.net/0e71/f/2015/262/d/a/oscar_png__06__anticlove_game__by_nightmare_wonderful-d9a5ao1.png").first_or_create
AiPlayer.where(name: "Martha", bet_style: "conservative",
  avatar: "http://www.roscobandana.com/wp-content/uploads/2013/01/rosco7.jpg").first_or_create
AiPlayer.where(name: "Colbert", bet_style: "conservative",
  avatar: "http://img.timeinc.net/time/2012/poypoll/colbert.jpg").first_or_create
AiPlayer.where(name: "Engrid", bet_style: "aggressive",
  avatar: "https://pbs.twimg.com/profile_images/633056713541726208/6SptI0Ep.jpg").first_or_create
