class TurnSerializer < ActiveModel::Serializer
  attributes :_embedded, :_links

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
end
