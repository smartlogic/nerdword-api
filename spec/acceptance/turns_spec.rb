require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Turns" do
  include_context :auth
  include_context :routes

  let(:game) do
    gcs = GameCreationService.new([user])
    gcs.perform
    gcs.game
  end
  let(:game_id) { game.id }

  before do
    game.update_attributes(:random_seed => 10)
  end

  get "/games/:game_id/turns" do
    example_request "Viewing all turns for a game" do
      response_body.should be_json_eql({
        :_embedded => {
          :turns => [
            {
              :rack => "CATORRI",
              :_embedded => {
                :user => { :email => user.email }
              },
              :_links => {
                :self => { :href => game_turn_url(game, game.turns.first, :host => host) }
              }
            }
          ]
        },
        :_links => {
          CoreRels.rel("game") => { :href => game_url(game, :host => host) },
          :self => { :href => game_turns_url(game, :host => host) }
        }
      }.to_json)

      status.should == 200
    end
  end

  get "/games/:game_id/turns/:id" do
    let(:turn) { game.turns.first }
    let(:id) { turn.id }

    example_request "Viewing a single turn" do
      response_body.should be_json_eql( {
        :rack => "CATORRI",
        :_embedded => {
          :user => { :email => user.email }
        },
        :_links => {
          :self => { :href => game_turn_url(game, game.turns.first, :host => host) }
        }
      }.to_json)

      status.should == 200
    end
  end
end
