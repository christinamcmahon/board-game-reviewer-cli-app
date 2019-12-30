class CreateBoardGames < ActiveRecord::Migration[5.1]
  def change
    create_table :board_games do |t|
      t.string :title
    end
  end
end
