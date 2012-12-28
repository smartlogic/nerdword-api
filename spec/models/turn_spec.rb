require 'spec_helper'

describe Turn do
  describe "#move" do
    it "should return a move object" do
      turn = Turn.new(:word => "NESTOR", :row => 0, :col => 1, :direction => Direction::HORIZONTAL)
      turn.move.should == Move.new("NESTOR", Position.new(1, 0), Direction::HORIZONTAL)
    end

    it "should return nil if a move has not been played" do
      turn = Turn.new
      turn.move.should be_nil
    end
  end
end
