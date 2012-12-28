require 'move'
require 'position'

class GamePlayService < Struct.new(:user, :game, :params)
  attr_reader :next_turn

  def perform
    move = Move.new(params[:word], Position.new(params[:row], params[:column]), params[:direction])
    game.play(user, move)
  end
end
