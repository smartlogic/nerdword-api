require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Root" do
  include Rails.application.routes.url_helpers

  let(:host) { "example.org" }

  get "/" do
    example_request "Root resource" do
      response_body.should be_json_eql({
        :_links => {
          :self => { :href => root_url(:host => host) }
        }
      }.to_json)
      status.should == 200
    end
  end
end
