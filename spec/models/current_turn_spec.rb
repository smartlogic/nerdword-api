require 'spec_helper'

describe CurrentTurn do
  let(:current_turn) { CurrentTurn.new(user, users, random_seed, turns, Random) }

  let(:user) { mock(:user) }
  let(:users) { [user] }
  let(:random_seed) { 10 }
  let(:turns) { [] }

  describe "#rack" do
    it "should be able to get the current rack" do
      current_turn.rack.should == "CATORRI"
    end

    context "two players" do
      let(:user_2) { mock(:user) }
      let(:users) { [user, user_2] }

      it "should load both racks" do
        current_turn.rack.should == "CATORRI"

        current_turn = CurrentTurn.new(user_2, users, random_seed, turns, Random)
        current_turn.rack.should == "SZFANIR"
      end
    end
  end
end
