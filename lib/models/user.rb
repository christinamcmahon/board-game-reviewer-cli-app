class User < ActiveRecord::Base
  has_many :reviews
  has_many :board_games, through: :reviews
end
