require 'spec_helper'

describe Turn do
  describe "#move" do
    it "should return a move object" do
      turn = Turn.new(:word => "NESTOR", :row => 0, :col => 1, :direction => Nerdword::Direction::HORIZONTAL)
      turn.move.should == Nerdword::Move.new("NESTOR", Nerdword::Position.new(1, 0), Nerdword::Direction::HORIZONTAL)
    end

    it "should return nil if a move has not been played" do
      turn = Turn.new
      turn.move.should be_nil
    end
  end
end
