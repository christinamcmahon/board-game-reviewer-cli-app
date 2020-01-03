require "tty-prompt"
require "colorize"
require "tty-font"

class CommandLineInterface
  @@prompt = TTY::Prompt.new
  @@font = TTY::Font.new(:block)
  @@current_user_id = 0
  @@crud = nil

  ### Run Method ###

  def run
    greet
    @@crud = Crud.new(@@prompt, @@current_user_id)
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
    reviews_menu(board_game_id)
  end

  def reviews_menu(board_game_id = nil)
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
        @@crud.write_board_game_review(board_game_id)
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
end
