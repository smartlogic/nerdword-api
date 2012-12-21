class GameCreationService < Struct.new(:users)
  include ActiveModel::Validations

  attr_reader :game

  def perform
    @game = Game.new
    @game.users = users
    @game.save
  end
end
