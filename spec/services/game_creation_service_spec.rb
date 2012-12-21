require 'spec_helper'

describe GameCreationService do
  let(:service) { GameCreationService.new(users) }

  let(:user_1) { mock(:user_1) }
  let(:user_2) { mock(:user_2) }
  let(:users) { [user_1, user_2] }

  let(:game) { mock(:game) }

  it "should create a new game" do
    Game.should_receive(:new).and_return(game)
    game.should_receive(:users=).with(users).and_return(users)
    game.should_receive(:save)

    service.perform
    service.game.should == game
  end
end
