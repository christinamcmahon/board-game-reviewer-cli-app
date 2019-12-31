# option 1. Search for a specific board game
def find_board_game_by_title
  puts "Enter a board game title:"
  board_game_title = gets.chomp
  game = BoardGame.find_by(title: board_game_title)
  if game
    display_board_game_data(game)
    display_reviews(game)
  else
    "Could not find that game."
  end
end

def display_board_game_data(game)
  attributes_hash = game.attributes
  attributes_hash.each do |key, value|
    if key != "id"
      puts "#{key}: #{value}"
    end
  end
  # display reviews for this game
end

def display_reviews(game)
  reviews = Review.all.find_all { |review| review.board_game_id == game.id }
  reviews.each do |review|
    puts ""
    puts review.user.name
    puts ""
    puts review.text
    puts ""
  end
end
