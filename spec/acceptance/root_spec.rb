require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Root" do
  get "/" do
    example_request "Root resource" do
      response_body.should be_json_eql({}.to_json)
      status.should == 200
    end
  end
end
