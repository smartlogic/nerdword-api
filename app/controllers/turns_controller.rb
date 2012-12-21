class TurnsController < ApplicationController
  let(:game) { current_user.games.find(params[:game_id]) }
  let(:turns) { game.turns }

  let(:turn) { turns.find(params[:id]) }

  def index
    render :json => turns, :serializer => TurnsSerializer, :game => game, :randomness => Rails.application.randomness
  end

  def show
    render :json => turn, :game => game, :randomness => Rails.application.randomness
  end
end
