require 'spec_helper'

describe CurrentTurn do
  let(:current_turn) { CurrentTurn.new(user, random_seed, turns) }

  let(:user) { mock(:user) }
  let(:random_seed) { 10 }
  let(:turns) { [] }

  describe "#rack" do
    it "should be able to get the current rack" do
      current_turn.rack.should == "CATORRI"
    end
  end
end
