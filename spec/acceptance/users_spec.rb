require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Users" do
  include_context :routes
  include_context :json

  post "/users" do
    parameter :email, "User's email"
    parameter :password, "User's password"

    let(:email) { "user@example.com" }
    let(:password) { "password" }

    let(:raw_post) { { :user => params }.to_json }

    example_request "Creating a new user" do
      response_body.should == ""

      status.should == 204

      client.get("/", {}, { "Authorization" => "Basic #{Base64.encode64("#{email}:password")}" })

      response_body.should be_json_eql({
        :_links => {
          CoreRels.rel("games") => { :href => games_url(:host => host) },
          :self => { :href => root_url(:host => host) }
        }
      }.to_json)

      status.should == 200
    end
  end
end
