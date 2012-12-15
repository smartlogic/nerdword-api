class TurnsController < ApplicationController
  let(:game) { current_user.games.find(params[:game_id]) }
  let(:turns) { game.turns }

  def index
    render :json => turns, :serializer => TurnsSerializer, :game => game
  end
end
