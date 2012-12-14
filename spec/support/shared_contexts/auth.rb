shared_context :auth do
  header "Authorization", :basic_auth

  let(:basic_auth) { "Basic #{Base64.encode64("#{user.email}:password")}" }
  let(:user) { User.create(:email => "eric@example.com", :password => "password") }
end
