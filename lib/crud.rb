class Crud
  def initialize(prompt, current_user_id)
    @@prompt = prompt
    @@current_user_id = current_user_id
  end

  ### Create Method ###

  def write_board_game_review(board_game_id)
    rating = rate
    review = write_review_text
    Review.create(rating: rating, review: review, user_id: @@current_user_id, board_game_id: board_game_id)
    puts "------------------------".colorize(:light_green)
    puts "Thank you for your review!".colorize(:cyan)
    selection = @@prompt.select("What you would like to do next?:", ["Back to main menu", "Exit"])
    case selection
    when "Back to main menu"
      main_menu
    when "Exit"
      exit_message
    end
  end

  ### Read Methods ###

  def see_current_users_reviews
    reviews = User.find(@@current_user_id).reviews
    num = 1
    if reviews.length == 0
      puts "You don't have any reviews yet!".colorize(:cyan)
    end
    reviews.each do |review|
      hash = review.attributes
      hash.each do |key, value|
        if key == "board_game_id"
          puts "#{num}. Title: #{BoardGame.find(hash["board_game_id"]).title}".colorize(:magenta)
        end
      end
      show_rating_and_review(hash)
      num += 1
    end
  end

  def see_reviews_for_this_game(board_game_id)
    reviews = Review.where(board_game_id: board_game_id)
    num = 1
    if reviews.length == 0
      puts "There aren't any reviews for this game.".colorize(:cyan)
    end
    reviews.each do |review|
      hash = review.attributes
      hash.each do |key, value|
        if key == "board_game_id"
          puts "#{num}. User: #{User.find(hash["user_id"]).name}".colorize(:magenta)
        end
      end
      show_rating_and_review(hash)
      num += 1
    end
  end

  ### Update Method ###

  def edit_review
    reviews = User.find(@@current_user_id).reviews
    see_current_users_reviews
    puts "------------------------".colorize(:light_green)
    options = [] # refactor?
    num = 1
    reviews.each do |review|
      options.push(num)
      num += 1
    end
    selection = @@prompt.select("Enter the number associated with the review you want to edit:", options)
    to_edit = reviews[selection - 1]
    rating = rate
    User.find(@@current_user_id).reviews[selection - 1].update_attribute(:rating, rating)
    review = write_review_text
    User.find(@@current_user_id).reviews[selection - 1].update_attribute(:review, review)
    edited_review = User.find(@@current_user_id).reviews[selection - 1]
    edited_hash = edited_review.attributes
    edited_hash.each do |key, value|
      if key == "board_game_id"
        puts "Title: #{BoardGame.find(edited_hash["board_game_id"]).title}".colorize(:magenta)
      end
    end
    show_rating_and_review(edited_hash)
    reviews_menu
  end

  ### Delete Method ###

  def delete_review
    reviews = User.find(@@current_user_id).reviews
    see_current_users_reviews
    puts "------------------------"
    options = []
    num = 1
    reviews.each do |review|
      options.push(num)
      num += 1
    end
    selection = @@prompt.select("Enter the number associated with the review you want to delete:", options)
    puts "------------------------".colorize(:light_green)
    options = ["Delete the review", "Never mind, go back to the main menu"]
    confirmation = @@prompt.select("Are you sure you want to delete this review?", options)
    if confirmation == "Delete the review"
      User.find(@@current_user_id).reviews[selection - 1].delete
      puts "------------------------".colorize(:light_green)
      puts "Your review has been deleted successfully.".colorize(:red)
    end
    main_menu
  end

  ### Helpers ###

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

  def rate
    @@prompt.ask("Enter a rating: 1-10?") { |q| q.in("1-10") }
  end

  def write_review_text
    @@prompt.ask("Write your review:")
  end
end
