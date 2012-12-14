class GamesController < ApplicationController
  let(:games) { current_user.games }

  def index
    render :json => games, :serializer => GamesSerializer
  end
end
