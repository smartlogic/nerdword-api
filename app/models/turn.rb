class Turn < ActiveRecord::Base
  belongs_to :game
  belongs_to :user

  attr_accessible :game, :user, :word, :row, :col, :direction

  def self.current_turn
    order(:id).last
  end

  def move
    if word
      Move.new(word, Position.new(col, row), direction)
    end
  end
end
