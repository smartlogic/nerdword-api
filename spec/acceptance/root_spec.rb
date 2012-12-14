require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Root" do
  include_context :routes

  header "Authorization", :basic_auth

  let(:basic_auth) { "Basic #{Base64.encode64("#{user.email}:password")}" }

  let(:user) { User.create(:email => "eric@example.com", :password => "password") }

  get "/" do
    example_request "Root resource" do
      response_body.should be_json_eql({
        :_links => {
          CoreRels.rel("games") => { :href => games_url(:host => host) },
          :self => { :href => root_url(:host => host) }
        }
      }.to_json)
      status.should == 200
    end

    context "user unauthorized" do
      let(:basic_auth) { "" }

      example_request "Root resource - unauthorized" do
        response_body.should be_json_eql({
          :_links => {
            :self => { :href => root_url(:host => host) }
          }
        }.to_json)
        response_headers["WWW-Authenticate"].should == "Basic realm=\"Nerdword\""
        status.should == 401
      end
    end
  end
end
