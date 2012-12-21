require 'pouch'
require 'player'

class CurrentTurn < Struct.new(:user, :users, :random_seed, :turns, :randomness)
  def rack
    racks = users.inject({}) do |racks, user|
      rack = []
      Player.new(nil, pouch, rack).draw
      racks.merge(user => rack.join)
    end
    racks[user]
  end

  private

  def pouch
    @pouch ||= Pouch.new(Tile::REGULAR_DISTRIBUTION.dup, randomness.new(random_seed))
  end
end
