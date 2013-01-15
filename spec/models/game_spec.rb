require 'spec_helper'

describe Game do
  # create the CurrentState object to get the current state of the board
  # play the move on the current board
  # save the move in the current turn
  # create next turn
  describe "#play" do
    let(:move) { Nerdword::Move.new("GAME", Nerdword::Position.new(0, 1), Nerdword::Direction::HORIZONTAL) }

    let(:user) { User.create }
    let(:user_2) { User.create }

    it "should save the move and create the next one" do
      turn = Turn.create

      game = Game.create
      game.users = [user, user_2]
      game.turns = [turn]

      game.play(user, move)

      turn.reload
      turn.word.should == move.word
      turn.row.should == move.position.row
      turn.col.should == move.position.col
      turn.direction.should == move.direction

      game.should have(2).turns
    end
  end
end
