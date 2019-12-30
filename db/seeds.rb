User.create(name: Faker::Name.name)
BoardGame.create(title: Faker::Game.title)
Review.create(text: Faker::Lorem.sentence, user_id: User.all.sample.id, board_game_id: BoardGame.all.sample.id, rating: rand(1..10))
