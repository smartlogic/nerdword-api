class GamePlayService < Struct.new(:user, :game, :params)
  attr_reader :next_turn

  def perform
    move = Nerdword::Move.new(params[:word], Nerdword::Position.new(params[:column], params[:row]), params[:direction])
    game.play(user, move)
  end
end
