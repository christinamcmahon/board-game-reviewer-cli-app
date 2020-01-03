require "tty-prompt"
require "colorize"
require "tty-font"

class CommandLineInterface
  @@prompt = TTY::Prompt.new
  @@font = TTY::Font.new(:block)
  @@current_user_id = 0

  ### Run Method ###

  def run
    greet
    main_menu
  end

  ### Main Menu Methods ###

  def greet
    puts @@font.write("Welcome").colorize(:light_green)
    puts "This is My Board Games Reviewer!".colorize(:cyan)
    puts "Let me help you find an awesome game to play!".colorize(:cyan)
    name = @@prompt.ask("What is your name?", default: "User")
    current_user = User.find_or_create_by(name: name)
    @@current_user_id = current_user.id
    puts "Nice to meet you, #{name}!".colorize(:cyan)
  end

  def main_menu
    puts ""
    query = "Choose a game to review: (Scroll for more options)"
    options = ["Bananagrams", "Codenames", "King of Tokyo", "Magic: the Gathering", "Mysterium", "Settlers of Catan", "Splendor", "Taboo", "Ticket to Ride", "Uno", "See all of my reviews", "Exit"]
    selection = @@prompt.select(query, options)
    if selection == "See all of my reviews"
      see_current_users_reviews
      reviews_menu(nil)
    elsif selection == "Exit"
      exit_message
    else
      print_game_info(selection)
      games_menu(BoardGame.where(title: selection).first.id)
    end
  end

  ### Sub Menu Methods ###

  def print_game_info(title)
    board_game = BoardGame.where(title: title)
    hash = board_game.first.attributes
    puts "------------------------".colorize(:light_green)
    puts "#{hash["title"]} (#{hash["year_published"]})".colorize(:magenta)
    board_game_id = hash["id"]
    puts "Average Rating: #{average_rating(board_game_id)}".colorize(:light_magenta)
    min_players = hash["min_players"]
    max_players = hash["max_players"]
    if max_players == 1
      puts "1 Player".colorize(:light_magenta)
    elsif min_players == max_players
      puts "#{max_players} Players".colorize(:light_magenta)
    else
      puts "#{min_players} - #{max_players} Players".colorize(:light_magenta)
    end
    puts "Average Play Time: #{hash["playing_time"]} Minutes".colorize(:light_magenta)
    puts "Age: #{hash["age"]}+".colorize(:light_magenta)
    puts "Complexity Rating: #{hash["complexity_rating"]}/5".colorize(:light_magenta)
    puts "Description: #{hash["description"]}".colorize(:light_magenta)
    puts "------------------------".colorize(:light_green)
  end

  def reviews_menu(board_game_id = nil)
    reviews = User.find(@@current_user_id).reviews
    query = "Please select an option:"
    options = ["Write a review", "Edit a review", "Delete a review", "Back to main menu"]
    selection = @@prompt.select(query, options)
    case selection
    when "Write a review"
      if board_game_id == nil
        puts "You must first select a game from the main menu.".colorize(:cyan)
        main_menu
      else
        write_board_game_review(board_game_id)
      end
    when "Edit a review"
      if reviews.length == 0
        puts "You do not have any reviews to edit.".colorize(:red)
        main_menu
      else
        edit_review
      end
    when "Delete a review"
      if reviews.length == 0
        puts "You do not have any reviews to delete.".colorize(:red)
        main_menu
      else
        delete_review
      end
    when "Back to main menu"
      main_menu
    end
  end

  def games_menu(board_game_id = nil) # Refactor!
    reviews = User.find(@@current_user_id).reviews
    query = "Please select an option:"
    options = ["Write a review", "Edit a review", "Delete a review", "See reviews for this game", "Back to main menu"]
    selection = @@prompt.select(query, options)
    case selection
    when "Write a review"
      if board_game_id == nil
        puts "You must first select a game from the main menu.".colorize(:cyan)
        main_menu
      else
        write_board_game_review(board_game_id)
      end
    when "Edit a review"
      if reviews.length == 0
        puts "You do not have any reviews to edit.".colorize(:red)
        main_menu
      else
        edit_review
      end
    when "Delete a review"
      if reviews.length == 0
        puts "You do not have any reviews to delete.".colorize(:red)
        main_menu
      else
        delete_review
      end
    when "See reviews for this game"
      see_reviews_for_this_game(board_game_id)
      reviews_menu
    when "Back to main menu"
      main_menu
    end
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

  ### Bonus Methods ###

  def average_rating(board_game_id)
    sum = 0.0
    board_game_reviews = BoardGame.where(id: board_game_id).first.reviews
    board_game_reviews.each do |review|
      sum += review["rating"]
    end
    sum / board_game_reviews.length
  end

  ### Other Methods ###

  def exit_message
    puts "Thanks for stopping by. Happy Gaming!".colorize(:cyan)
    puts @@font.write("Goodbye").colorize(:light_green)
    puts ""
    exit
  end

  def get_input
    gets.chomp
  end

  def rate
    @@prompt.ask("Enter a rating: 1-10?") { |q| q.in("1-10") }
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

  def write_review_text
    @@prompt.ask("Write your review:")
  end
end
