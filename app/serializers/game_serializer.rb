class GameSerializer < ActiveModel::Serializer
  attributes :_embedded, :_links

  def _embedded
    { :users => users }
  end

  def _links
    {
      CoreRels.rel("turns") => { :href => game_turns_url(game) },
      CoreRels.rel("current-turn") => { :href => game_turn_url(game, game.current_turn) },
      :self => { :href => game_url(game) }
    }
  end

  private

  def users
    game.users.map do |user|
      UserSerializer.new(user)
    end
  end
end
