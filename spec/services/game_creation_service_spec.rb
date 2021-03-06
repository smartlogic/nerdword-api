require 'spec_helper'

describe GameCreationService do
  let(:service) { GameCreationService.new(users) }

  let(:user_1) { mock(:user_1) }
  let(:user_2) { mock(:user_2) }
  let(:users) { [user_1, user_2] }

  let(:game) { mock(:game) }

  let(:random) { mock(:random, :seed => 10) }

  it "should create a new game" do
    Random.should_receive(:new).and_return(random)

    Game.should_receive(:create).with({
      :users => users,
      :random_seed => 10
    }).and_return(game)

    Turn.should_receive(:create).with({
      :user => user_1,
      :game => game
    })

    service.perform
    service.game.should == game
  end

  it "can inject the random seed" do
    service = GameCreationService.new(users, 11)

    Game.should_receive(:create).with({
      :users => users,
      :random_seed => 11
    }).and_return(game)

    Turn.should_receive(:create).with({
      :user => user_1,
      :game => game
    })

    service.perform
  end
end
