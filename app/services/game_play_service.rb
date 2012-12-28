require 'move'
require 'position'

class GamePlayService < Struct.new(:user, :game, :params)
  attr_reader :next_turn

  def perform
    move = Move.new(params[:word], Position.new(params[:column], params[:row]), params[:direction])
    game.play(user, move)
  end
end
