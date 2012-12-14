class GameSerializer < ActiveModel::Serializer
  attributes :_embedded, :_links

  def _embedded
    { :users => users }
  end

  def _links
    { :self => { :href => game_url(game) } }
  end

  private

  def users
    game.users.map do |user|
      UserSerializer.new(user)
    end
  end
end
