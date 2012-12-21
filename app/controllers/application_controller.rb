class ApplicationController < ActionController::API
  extend Letter

  class UserUnauthorizedError < StandardError; end

  before_filter :authorize_user!

  rescue_from UserUnauthorizedError do
    response.headers["WWW-Authenticate"] = %{Basic realm="Nerdword"}
    render :json => Root.new, :serializer => RootSerializer, :status => 401
  end

  private

  def render(options)
    super({ :scope => current_user }.merge(options))
  end

  def current_user
    @current_user
  end

  def authorize_user!
    authorization = request.headers["Authorization"] || ""
    authorization = Base64.decode64(authorization.gsub("Basic ", ""))
    email, password = authorization.split(":")

    user = User.find_by_email(email)
    raise UserUnauthorizedError unless user
    raise UserUnauthorizedError unless user.password == password

    @current_user = user
  end
end
