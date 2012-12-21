class GameCreationService < Struct.new(:users, :random_seed)
  attr_reader :game

  def perform
    @game = Game.create({
      :users => users,
      :random_seed => random_seed
    })

    Turn.create({
      :user => users.first,
      :game => game
    })
  end

  private

  def random_seed
    super || Random.new.seed
  end
end
