class TurnSerializer < ActiveModel::Serializer
  attributes :_embedded, :_links, :rack

  def rack
    CurrentState.new(scope, game.users.game_order, game.random_seed.to_i, turns, @options[:randomness]).rack
  end

  def _embedded
    { :user => user }
  end

  def _links
    {
      :self => { :href => game_turn_url(turn.game, turn) }
    }
  end

  private

  def user
    UserSerializer.new(turn.user)
  end

  def game
    @options[:game]
  end

  def turns
    game.turns.order(:id).where("id < ?", turn.id)
  end
end
