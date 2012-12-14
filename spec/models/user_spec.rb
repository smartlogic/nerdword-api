require 'spec_helper'

describe User do
  it "should encrypt the password" do
    subject.password = "hi"
    subject.password_hash.should_not be_empty
    subject.password.should == "hi"
  end
end
