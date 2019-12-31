christina = User.create(name: "Christina")
debby = User.create(name: "Debby")
sean = User.create(name: "Sean")

bananagrams = BoardGame.create(title: "Bananagrams", year_published: 2006, min_players: 1, max_players: 8, playing_time: 15, age: 7, complexity_rating: 1.35, description: "Bananagrams is a fast and fun word game that requires no pencil, paper or board, and the tiles come in a fabric banana-shaped carrying pouch.")
codenames = BoardGame.create(title: "Codenames", year_published: 2015, min_players: 2, max_players: 8, playing_time: 15, age: 14, complexity_rating: 1.31, description: "In Codenames, two teams compete to see who can make contact with all of their agents first. Spymasters give one-word clues that can point to multiple words on the board.")
king_of_tokyo = BoardGame.create(title: "King of Tokyo", year_published: 2011, min_players: 2, max_players: 6, playing_time: 30, age: 8, complexity_rating: 1.5, description: "In King of Tokyo, you play mutant monsters, gigantic robots, and strange aliens—all of whom are destroying Tokyo and whacking each other in order to become the one and only King of Tokyo.")
mtg = BoardGame.create(title: "Magic: the Gathering", year_published: 1993, min_players: 2, max_players: 2, playing_time: 20, age: 13, complexity_rating: 3.19, description: "In the Magic game, you play the role of a planeswalker—a powerful wizard who fights other planeswalkers for glory, knowledge, and conquest. Your deck of cards represents all the weapons in your arsenal. It contains the spells you know and the creatures you can summon to fight for you.")
mysterium = BoardGame.create(title: "Mysterium", year_published: 2015, min_players: 2, max_players: 7, playing_time: 42, age: 10, complexity_rating: 1.91, description: "In Mysterium, one player takes the role of ghost while everyone else represents a medium. To solve the crime, the ghost must first recall (with the aid of the mediums) all of the suspects present on the night of the murder.")
settlers = BoardGame.create(title: "Settlers of Catan", year_published: 1995, min_players: 3, max_players: 4, playing_time: 60, age: 10, complexity_rating: 2.33, description: "In Catan, players try to be the dominant force on the island of Catan by building settlements, cities, and roads.")
splendor = BoardGame.create(title: "Splendor", year_published: 2014, min_players: 2, max_players: 4, playing_time: 30, age: 10, complexity_rating: 1.81, description: "Splendor is a game of chip-collecting and card development. Players are merchants of the Renaissance trying to buy gem mines, means of transportation, shops—all in order to acquire the most prestige points.")
taboo = BoardGame.create(title: "Taboo", year_published: 1989, min_players: 4, max_players: 10, playing_time: 20, age: 12, complexity_rating: 1.23, description: "Taboo is a party word game. Players take turns describing a word or phrase on a drawn card to their partner without using five common additional words or phrases also on the card.")
ticket_to_ride = BoardGame.create(title: "Ticket to Ride", year_published: 2004, min_players: 2, max_players: 5, playing_time: 45, age: 8, complexity_rating: 1.86, description: "In Ticket to Ride, players collect cards of various types of train cars they then use to claim railway routes in North America.")
uno = BoardGame.create(title: "Uno", year_published: 1971, min_players: 2, max_players: 10, playing_time: 30, age: 6, complexity_rating: 1.12, description: "In Uno, players race to empty their hands and catch opposing players with cards left in theirs, which score points.")

christinas_codenames_review = Review.create(review: "The best party word game!", user_id: christina.id, board_game_id: codenames.id, rating: 9)
christinas_splendor_review = Review.create(review: "Great resource collecting game for up to 4 players", user_id: christina.id, board_game_id: splendor.id, rating: 9)
debbys_splendor_review = Review.create(review: "It's alright, I guess", user_id: debby.id, board_game_id: splendor.id, rating: 6)
debbys_ticket_to_ride_review = Review.create(review: "This game takes too long to learn", user_id: debby.id, board_game_id: ticket_to_ride.id, rating: 5)
seans_king_of_tokyo_review = Review.create(review: "Good game for when you just want to have fun without having to think too hard", user_id: sean.id, board_game_id: king_of_tokyo.id, rating: 8)
seans_splendor_review = Review.create(review: "My favorite game!", user_id: sean.id, board_game_id: splendor.id, rating: 10)
