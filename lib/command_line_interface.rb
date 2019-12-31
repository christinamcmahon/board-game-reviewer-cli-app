class CommandLineInterface
  current_user_id = 0

  def run
    greet
    main_menu
  end

  def greet
    puts "Welcome to My Board Games Reviewer!"
    puts "Thinking of playing one of my board games? Let me help you find an awesome game to play!"
    get_user_name
  end

  def get_user_name
    puts ""
    puts "What's your name: "
    name = gets.chomp
    puts ""
    current_user = User.find_or_create_by(name: name)
    $current_user_id = current_user.id
    puts "Nice to meet you, #{name}!"
  end

  def main_menu
    puts ""
    puts "------------------------"
    puts "Take a look at my games:"
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
    puts "" # Need to add an exit
    input = get_input.to_i
    if [1..10].include?(input)
      board_game_selection(input)
    else
      puts "That option does not exist. Please enter a number 1-10."
    end
  end

  def board_game_selection(board_game_num) # Refactor!
    case board_game_num
    when 1
      print_game_info("Bananagrams")
    when 2
      print_game_info("Codenames")
    when 3
      print_game_info("King of Tokyo")
    when 4
      print_game_info("Magic the Gathering")
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
    end
  end

  def print_game_info(title)
    selection = BoardGame.where(title: title)
    hash = selection.attributes
    hash.each do |key, value|
      if key != "id"
        puts "#{key}: #{value}"
      end
    end
    id = selection["id"]
    write_board_game_review(id)
  end

  ########## old code below #############

  def write_board_game_review
    puts "Please enter a rating 1 to 10:"
    rating = get_input.to_i
    puts ""
    while ![1, 2, 3, 4, 5, 6, 7, 8, 9, 10].include?(rating)
      puts "Please enter a valid rating between 1 and 10:"
      rating = get_input.to_i
    end
    puts "Enter your review:"
    review = get_input
    puts ""
    Review.create(rating: rating, review: review, user_id: $current_user_id, board_game_id: board_game_id)
    puts "--------------------------"
    puts "Thank you for your review!"
    puts "Select an option below."
    puts "1. See my reviews"
    puts "2. Write another review"
    puts "3. Exit"
    input = " "
    while input
      input = get_input
      case input
      when "1"
        see_reviews
        reviews_menu
      when "2"
        main_menu
      when "3"
        exit_message
      else
        puts "That option does not exist. Please enter a number 1-3."
      end
    end
  end

  def exit_message
    puts "Thanks for stopping by. Happy Gaming!"
    exit
  end

  def reviews_menu
    puts "------------------------"
    puts "Press enter to continue."
    gets.chomp
    puts "------------------------"
    puts "Please select an option:"
    puts "1. Edit review"
    puts "2. Delete review"
    puts "3. Back to main menu"
    input = get_input.to_i
    while ![1, 2, 3].include?(input)
      puts "Please enter a valid rating between 1 and 3:"
      input = get_input.to_i
    end
    case input
    when 1
      edit_review
    when 2
      delete_review
    when 3
      main_menu
    end
  end

  def see_reviews
    reviews = User.find($current_user_id).reviews
    num = 1
    reviews.each do |review|
      hash = review.attributes
      hash.each do |key, value|
        if key == "board_game_id"
          puts "#{num}. title: #{BoardGame.find(hash["board_game_id"]).name}"
        end
      end
      hash.each do |key, value|
        if key == "rating"
          puts "#{key}: #{value}"
        end
        if key == "review"
          puts "#{key}: #{value}"
        end
      end
      i += 1
    end
  end

  def edit_review
    reviews = User.find($current_user_id).reviews
    see_reviews
    puts "------------------------------------------------------------------------"
    puts "Please enter a number associated with the review you would like to edit:"
    selection = get_input.to_i
    while !(1..reviews.length).to_a.include?(num) #Refactor!
      puts "Please enter a valid number:"
      selection = get_input.to_i
    end
    to_edit = reviews[num - 1]
    # Refactor!

  end

  def get_input
    gets.chomp
  end
end
