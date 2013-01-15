require 'spec_helper'

describe CurrentState do
  let(:current_turn) { CurrentState.new(user, users, random_seed, turns, Random) }

  let(:user) { mock(:user) }
  let(:user_2) { mock(:user) }
  let(:users) { [user] }
  let(:random_seed) { 10 }

  let(:turn_1) { stub(:turn_1, :user => user, :move => move_1) }
  let(:turn_2) { stub(:turn_2, :user => user_2, :move => move_2) }
  let(:turn_3) { stub(:turn_3, :user => user, :move => nil) }

  let(:move_1) { Nerdword::Move.new("CATORRI", Nerdword::Position.new(0, 0), Nerdword::Direction::HORIZONTAL) }
  let(:move_2) { Nerdword::Move.new("ISZFANRI", Nerdword::Position.new(6, 0), Nerdword::Direction::VERTICAL) }

  describe "#rack" do
    context "first turn" do
      let(:turns) { [turn_3] }

      it "should be able to get the current rack" do
        current_turn.rack.should == "CATORRI"
      end

      context "two players" do
        let(:users) { [user, user_2] }

        it "should load both racks" do
          current_turn.rack.should == "CATORRI"

          current_turn = CurrentState.new(user_2, users, random_seed, turns, Random)
          current_turn.rack.should == "SZFANIR"
        end
      end
    end

    context "third turn" do
      let(:turns) { [turn_1, turn_2, turn_3] }
      let(:users) { [user, user_2] }

      it "should load the third turn racks" do
        current_turn.rack.should == "EAVTFLP"

        current_turn = CurrentState.new(user_2, users, random_seed, turns, Random)
        current_turn.rack.should == "AIBUEEO"
      end
    end
  end

  describe "#score" do
    context "first turn" do
      let(:turns) { [turn_3] }
      let(:users) { [user, user_2] }

      it "should load both scores" do
        current_turn.score.should == 0

        current_turn = CurrentState.new(user_2, users, random_seed, turns, Random)
        current_turn.score.should == 0
      end
    end

    context "third turn" do
      let(:turns) { [turn_1, turn_2, turn_3] }
      let(:users) { [user, user_2] }

      it "should load the third turn score" do
        current_turn.score.should == 57

        current_turn = CurrentState.new(user_2, users, random_seed, turns, Random)
        current_turn.score.should == 58
      end
    end

    context "fourth turn" do
      let(:turn_3) { stub(:turn_2, :user => user, :move => move_3) }
      let(:turn_4) { stub(:turn_2, :user => user_2, :move => nil) }

      let(:move_3) { Nerdword::Move.new("AT", Nerdword::Position.new(1, 0), Nerdword::Direction::VERTICAL) }

      let(:turns) { [turn_1, turn_2, turn_3, turn_4] }
      let(:users) { [user, user_2] }

      it "should load the third turn score" do
        current_turn.score.should == 59

        current_turn = CurrentState.new(user_2, users, random_seed, turns, Random)
        current_turn.score.should == 58
      end
    end
  end
end
