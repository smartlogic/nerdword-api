class Game < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :turns

  attr_accessible :users, :random_seed

  delegate :current_turn, :to => :turns

  def next_user(current_user)
    lusers = users.game_order
    lusers[(lusers.index(current_user) + 1) % lusers.count]
  end

  def play(user, move)
    current_turn.update_attributes({
      :word => move.word,
      :row => move.position.row,
      :col => move.position.col,
      :direction => move.direction
    })

    turns.create(:user => next_user(user))
  end
end
