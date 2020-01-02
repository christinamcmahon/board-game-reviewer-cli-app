class CommandLineInterface
  current_user_id = 0

  ### Run Method ###

  def run
    greet
    main_menu
  end

  ### Main Menu Methods ###

  def greet
    puts "Welcome to My Board Games Reviewer!"
    puts "Thinking of playing one of my board games? Let me help you find an awesome game to play!"
    get_user_name
  end

  def get_user_name
    puts ""
    puts "What's your name?"
    name = get_input.to_s
    puts ""
    current_user = User.find_or_create_by(name: name)
    $current_user_id = current_user.id
    puts "Nice to meet you, #{name}!"
  end

  def main_menu
    puts ""
    puts "------------------------"
    puts "Choose a game to review:"
    puts "------------------------"
    puts ""
    puts "1. Bananagrams"
    puts "2. Codenames"
    puts "3. King of Tokyo"
    puts "4. Magic the Gathering"
    puts "5. Mysterium"
    puts "6. Settlers of Catan"
    puts "7. Splendor"
    puts "8. Taboo"
    puts "9. Ticket to Ride"
    puts "10. Uno"
    puts ""
    puts "11. See all of my reviews"
    puts "12. Exit"
    input = get_input.to_i
    while ![1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12].include?(input)
      puts "That option does not exist. Please enter a number 1 - 11."
      input = get_input.to_i
    end
    main_menu_selection(input)
  end

  def main_menu_selection(main_menu_num)
    case main_menu_num
    when 1
      print_game_info("Bananagrams")
    when 2
      print_game_info("Codenames")
    when 3
      print_game_info("King of Tokyo")
    when 4
      print_game_info("Magic: the Gathering")
    when 5
      print_game_info("Mysterium")
    when 6
      print_game_info("Settlers of Catan")
    when 7
      print_game_info("Splendor")
    when 8
      print_game_info("Taboo")
    when 9
      print_game_info("Ticket to Ride")
    when 10
      print_game_info("Uno")
    when 11
      see_reviews
      reviews_menu(nil)
    when 12
      exit_message
    end
  end

  ### Sub Menu Methods ###

  def print_game_info(title)
    input = BoardGame.where(title: title)
    hash = input.first.attributes
    puts "------------------------"
    puts "#{hash["title"]} (#{hash["year_published"]})"
    puts "Average Rating: #{average_rating(hash["id"]})
    min_players = hash["min_players"]
    max_players = hash["max_players"]
    if max_players == 1
      puts "1 Player"
    elsif min_players == max_players
      puts "#{max_players} Players"
    else
      puts "#{min_players} - #{max_players} Players"
    end
    puts "Average Play Time: #{hash["playing_time"]} Minutes"
    puts "Age: #{hash["age"]}+"
    puts "Complexity Rating: #{hash["complexity_rating"]}/5"
    puts "Description: #{hash["description"]}"
    puts "------------------------"
    reviews_menu(hash["id"])
  end

  def reviews_menu(board_game_id = nil)
    puts "Please select an option:"
    puts "1. Write a review"
    puts "2. Edit one of my reviews"
    puts "3. Delete one of my reviews"
    puts "4. Back to main menu"
    input = get_input.to_i
    while ![1, 2, 3, 4].include?(input)
      puts "Please enter a valid option:"
      input = get_input.to_i
    end
    case input
    when 1
      if board_game_id == nil
        puts "You must first select a game from the main menu."
        main_menu
      else
        write_board_game_review(board_game_id)
      end
    when 2
      edit_review
    when 3
      delete_review
    when 4
      main_menu
    end
  end

  ### Create Method ###

  def write_board_game_review(board_game_id)
    rating = rate
    review = write_review_text
    Review.create(rating: rating, review: review, user_id: $current_user_id, board_game_id: board_game_id)
    puts "------------------------"
    puts "Thank you for your review!"
    puts "Select an option below."
    puts "1. Write another review"
    puts "2. Exit"
    input = get_input.to_i
    while ![1, 2].include?(input) #is there a way to refactor this?
      puts "Please enter a valid rating between 1 and 3:"
      input = get_input.to_i
    end
    case input
    when 1
      main_menu
    when 2
      exit_message
    end
  end

  ### Read Method ###

  def see_reviews
    reviews = user_reviews
    num = 1
    if reviews.length == 0
      puts "You don't have any reviews yet!"
    end
    reviews.each do |review|
      hash = review.attributes
      hash.each do |key, value|
        if key == "board_game_id"
          puts "#{num}. Title: #{BoardGame.find(hash["board_game_id"]).title}"
        end
      end
      show_rating_and_review(hash)
      num += 1
    end
  end

  ### Update Method ###

  def edit_review
    reviews = user_reviews
    see_reviews
    puts "------------------------"
    puts "Please enter a number associated with the review you would like to edit:"
    selection = get_input.to_i
    while !(1..reviews.length).to_a.include?(selection)
      puts "Please enter a valid number:"
      selection = get_input.to_i
    end
    to_edit = reviews[selection - 1]
    rating = rate
    User.find($current_user_id).reviews[selection - 1].update_attribute(:rating, rating)
    review = write_review_text
    User.find($current_user_id).reviews[selection - 1].update_attribute(:review, review)
    edited_review = User.find($current_user_id).reviews[selection - 1]
    edited_hash = edited_review.attributes
    edited_hash.each do |key, value|
      if key == "board_game_id"
        puts "Title: #{BoardGame.find(edited_hash["board_game_id"]).title}"
      end
    end
    show_rating_and_review(edited_hash)
    reviews_menu
  end

  ### Delete Method ###

  def delete_review
    reviews = user_reviews
    see_reviews
    puts "------------------------"
    puts "Enter a number associated with the review you want to delete:"
    selection = get_input.to_i
    while !(1..reviews.length).to_a.include?(selection)
      puts "Please enter a valid number:"
      selection = get_input.to_i
    end
    puts "------------------------"
    puts "Are you sure you want to delete this review?"
    puts "Please select an option below:"
    puts "1. Delete the review"
    puts "2. Never mind, go back to the main menu"
    confirmation = get_input.to_i
    while ![1, 2].include?(confirmation)
      puts "Please enter a valid number:"
      confirmation = get_input.to_i
    end
    if confirmation == 1
      User.find($current_user_id).reviews[selection - 1].delete
      puts "------------------------"
      puts "Your review has been deleted successfully."
    end
    main_menu
  end

  ### Helper Methods ###

  def exit_message
    puts "Thanks for stopping by. Happy Gaming!"
    exit
  end

  def get_input
    gets.chomp
  end

  def rate
    puts "Please enter a rating 1 to 10:"
    rating = get_input.to_i
    puts ""
    while ![1, 2, 3, 4, 5, 6, 7, 8, 9, 10].include?(rating)
      puts "Please enter a valid rating between 1 and 10:"
      rating = get_input.to_i
    end
    rating
  end

  def show_rating_and_review(hash)
    hash.each do |key, value|
      if key == "rating"
        puts "Rating: #{value}"
      end
      if key == "review"
        puts "Review: #{value}"
      end
    end
  end

  def user_reviews
    User.find($current_user_id).reviews
  end

  def write_review_text
    puts "Write your review:"
    review = get_input
    puts ""
    review
  end

  def average_rating(board_game_id)
    sum = 0
    BoardGame.where(board_game_id).reviews.each do |review|
      sum += review.rating
    end
    sum / Review.all.length
  end
end
