class GameSerializer < ActiveModel::Serializer
  attribute :_embedded

  def _embedded
    { :users => users }
  end

  private

  def users
    game.users.map do |user|
      UserSerializer.new(user)
    end
  end
end
