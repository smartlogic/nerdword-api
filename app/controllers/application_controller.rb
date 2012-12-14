class ApplicationController < ActionController::API
  class UserUnauthorizedError < StandardError; end

  before_filter do
    authorization = request.headers["Authorization"]
    authorization = Base64.decode64(authorization.gsub("Basic ", ""))
    email, password = authorization.split(":")

    user = User.find_by_email(email)
    raise UserUnauthorizedError unless user
    raise UserUnauthorizedError unless user.password == password
  end

  rescue_from UserUnauthorizedError do
    response.headers["WWW-Authenticate"] = %{Basic realm="Nerdword"}
    render :json => Root.new, :serializer => RootSerializer, :status => 401
  end
end
