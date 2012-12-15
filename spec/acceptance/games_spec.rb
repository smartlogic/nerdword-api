require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Games" do
  include_context :auth
  include_context :routes

  get "/games" do
    let!(:game) { Game.create(:users => [user]) }

    example_request "Listing all of your current games" do
      response_body.should be_json_eql({
        :_embedded => {
          :games => [
            {
              :_embedded => {
                :users => [{ :email => "eric@example.com" }]
              },
              :_links => {
                CoreRels.rel("game_turns") => { :href => game_turns_url(game, :host => host) },
                :self => { :href => game_url(game, :host => host) }
              }
            }
          ]
        },
        :_links => {
          :self => { :href => games_url(:host => host) }
        }
      }.to_json)
      status.should == 200
    end
  end

  get "/games/:id" do
    let(:game) { Game.create(:users => [user]) }
    let(:id) { game.id }

    example_request "Viewing a single game" do
      response_body.should be_json_eql({
        :_embedded => {
          :users => [{ :email => "eric@example.com" }]
        },
        :_links => {
          CoreRels.rel("game_turns") => { :href => game_turns_url(game, :host => host) },
          :self => { :href => game_url(game, :host => host) }
        }
      }.to_json)
      status.should == 200
    end
  end

  post "/games" do
    parameter :players, "Array of email addresses"

    let(:raw_post) { params.to_json }

    let(:user2) { User.create(:email => "nestor@example.com") }
    let(:players) { [user2.email] }

    example_request "Creating a game" do
      response_body.should == " "
      status.should == 201

      client.get(response_headers["Location"], {}, headers)

      response_body.should be_json_eql({
        :_embedded => {
          :users => [
            { :email => "nestor@example.com" },
            { :email => "eric@example.com" }
          ]
        },
        :_links => {
          CoreRels.rel("game_turns") => { :href => game_turns_url(Game.first, :host => host) },
          :self => { :href => game_url(Game.first, :host => host) }
        }
      }.to_json)
    end
  end
end
