shared_context :auth do
  include_context :json

  header "Authorization", :basic_auth

  let(:basic_auth) { "Basic #{Base64.encode64("#{user.email}:password")}" }
  let(:user) { User.create(:email => "eric@example.com", :password => "password") }
end

shared_context :json do
  header "Accept", "application/json"
  header "Content-Type", "application/json"
end
