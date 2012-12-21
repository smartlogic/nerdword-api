require 'pouch'
require 'player'
require 'board'

class CurrentTurn < Struct.new(:user, :random_seed, :turns)
  def rack
    pouch.draw(7).join
  end

  private

  def pouch
    @pouch ||= Pouch.new(Tile::REGULAR_DISTRIBUTION, Random.new(random_seed))
  end
  
  def board
    @board ||= Board.new(Hash.new(1))
  end
end
