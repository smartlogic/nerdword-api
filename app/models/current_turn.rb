require 'pouch'
require 'player'
require 'board'

class CurrentTurn < Struct.new(:user, :users, :random_seed, :turns, :randomness)
  def rack
    play_history

    players[users.index(user)][:rack].join
  end

  def score
    play_history

    players[users.index(user)][:player].score
  end

  private

  def play_history
    # First turn
    players.each do |player|
      player[:player].draw
    end

    turns.each do |turn|
      player = players[users.index(turn.user)]

      if turn.move
        player[:player].play(turn.move)
        player[:player].draw
      end
    end
  end

  def players
    @players ||= users.map do
      rack = []
      { :player => Player.new(board, pouch, rack), :rack => rack }
    end
  end

  def board
    @board ||= Board.new(Hash.new(1))
  end

  def pouch
    @pouch ||= Pouch.new(Tile::REGULAR_DISTRIBUTION.dup, randomness.new(random_seed))
  end
end
