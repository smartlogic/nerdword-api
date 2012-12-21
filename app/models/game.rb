class Game < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :turns

  attr_accessible :users, :random_seed

  def next_user(current_user)
    lusers = users.game_order
    lusers[(lusers.index(current_user) + 1) % lusers.count]
  end
end
