class AddColumnsToBoardGame < ActiveRecord::Migration[5.1]
  add_column(:board_games, :year_published, :integer)
  add_column(:board_games, :min_players, :integer)
  add_column(:board_games, :max_players, :integer)
  add_column(:board_games, :playing_time, :integer)
  add_column(:board_games, :age, :integer)
  add_column(:board_games, :complexity_rating, :float)
  add_column(:board_games, :description, :text)
end
