require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Games" do
  include_context :auth
  include_context :routes

  let!(:game) { Game.create(:users => [user]) }

  get "/games" do
    example_request "Listing all of your current games" do
      response_body.should be_json_eql({
        :_embedded => {
          :games => [
            {
              :_embedded => {
                :users => [{ :email => "eric@example.com" }]
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
end
