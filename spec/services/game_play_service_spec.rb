require 'spec_helper'

describe GamePlayService do
  let(:service) { GamePlayService.new(user, game, params) }

  let(:user) { stub(:user) }
  let(:game) { mock(:game) }
  let(:params) { {
    :word => "CAT",
    :row => 7,
    :column => 7,
    :direction => Direction::HORIZONTAL
  } }

  it "plays a move" do
    move = Move.new("CAT", Position.new(7, 7), Direction::HORIZONTAL)
    game.should_receive(:play).with(user, move)
    service.perform
  end
end
