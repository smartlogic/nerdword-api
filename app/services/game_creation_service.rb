class GameCreationService < Struct.new(:users)
  attr_reader :game

  def perform
    @game = Game.create({
      :users => users,
      :random_seed => Random.new.seed
    })

    Turn.create({
      :user => users.first,
      :game => game
    })
  end
end
