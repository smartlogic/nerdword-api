class Turn < ActiveRecord::Base
  belongs_to :game
  belongs_to :user

  attr_accessible :game, :user
end
