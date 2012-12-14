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
    game = Game.new
    game.users << current_user
    params[:players].map do |player_email|
      game.users << User.find_by_email(player_email)
    end
    game.save!
    head :created, :location => game_url(game)
  end
end
