class GamesController < ApplicationController
  let(:games) { current_user.games }
  let(:game) { current_user.games.find(params[:id]) }

  def index
    render :json => games, :serializer => GamesSerializer
  end

  def show
    render :json => game
  end

  def create
    users = [current_user] + User.where(:email => params[:players])
    service = GameCreationService.new(users)
    service.perform
    head :created, :location => game_url(service.game)
  end
end
